import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/medical_services/data/repositories/medical_services_repository.dart';
import 'package:erp/modules/webstore/medical_services/data/models/health_metric_model.dart';
import 'package:erp/modules/webstore/medical_services/data/models/symptom_chat_model.dart';
import 'package:erp/modules/webstore/medical_services/data/models/medication_reminder_model.dart';
import 'package:erp/modules/webstore/medical_services/data/models/ai_scan_result_model.dart';
import 'package:erp/modules/webstore/medical_services/data/models/daily_activity_model.dart';
import 'package:erp/core/services/local_notification_service.dart';

// ─── Data Layer Providers ──────────────────────────────────────

final medicalServicesRepositoryProvider = Provider<IMedicalServicesRepository>((ref) {
  return MockMedicalServicesRepository();
});

// ─── Health Profile Provider ───────────────────────────────────

final healthProfileProvider = AsyncNotifierProvider<HealthProfileViewModel, HealthProfileModel?>(
  HealthProfileViewModel.new,
);

class HealthProfileViewModel extends AsyncNotifier<HealthProfileModel?> {
  @override
  Future<HealthProfileModel?> build() async {
    final result = await ref.read(medicalServicesRepositoryProvider).getHealthProfile();
    return result.when(
      success: (data) => HealthProfileModel.fromJson(data),
      failure: (_) => null,
    );
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final result = await ref.read(medicalServicesRepositoryProvider).updateHealthProfile(data);
    result.when(
      success: (data) {
        state = AsyncValue.data(HealthProfileModel.fromJson(data));
      },
      failure: (_) {},
    );
  }
}

// ─── Health Metrics Provider ───────────────────────────────────

final healthMetricsProvider = AsyncNotifierProvider<HealthMetricsViewModel, List<HealthMetricModel>>(
  HealthMetricsViewModel.new,
);

class HealthMetricsViewModel extends AsyncNotifier<List<HealthMetricModel>> {
  @override
  Future<List<HealthMetricModel>> build() async {
    final result = await ref.read(medicalServicesRepositoryProvider).getHealthMetrics();
    return result.when(
      success: (data) => data.map((m) => HealthMetricModel.fromJson(m)).toList(),
      failure: (_) => [],
    );
  }

  Future<void> addMetric(Map<String, dynamic> data) async {
    final result = await ref.read(medicalServicesRepositoryProvider).addHealthMetric(data);
    result.when(
      success: (data) {
        final newMetric = HealthMetricModel.fromJson(data);
        state = AsyncValue.data([newMetric, ...state.value ?? []]);
      },
      failure: (_) {},
    );
  }
}

// ─── Symptom Chat Provider ─────────────────────────────────────

final symptomChatProvider = NotifierProvider<SymptomChatViewModel, SymptomChatState>(
  SymptomChatViewModel.new,
);

class SymptomChatState {
  final List<SymptomChatMessage> messages;
  final bool isLoading;
  final String? error;

  const SymptomChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  SymptomChatState copyWith({
    List<SymptomChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return SymptomChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SymptomChatViewModel extends Notifier<SymptomChatState> {
  @override
  SymptomChatState build() {
    Future.microtask(() => _initChat());
    return const SymptomChatState();
  }

  void _initChat() {
    final welcome = SymptomChatMessage(
      id: 'welcome',
      content: 'مرحباً! أنا مساعدك الطبي الذكي. وصفلي أعراضك وهحللها لك.',
      isUser: false,
      timestamp: DateTime.now(),
      options: [
        SymptomOption(id: 'headache', label: 'صداع', icon: '🤕'),
        SymptomOption(id: 'fever', label: 'حمى', icon: '🌡️'),
        SymptomOption(id: 'stomach', label: 'الم في المعدة', icon: '🤢'),
        SymptomOption(id: 'cold', label: 'برد', icon: '🤧'),
        SymptomOption(id: 'allergy', label: 'حساسية', icon: '🤧'),
        SymptomOption(id: 'joint', label: 'الم مفاصل', icon: '🦴'),
      ],
    );
    state = state.copyWith(messages: [welcome]);
  }

  Future<void> sendSymptoms(List<String> symptoms, {String? additionalInfo}) async {
    final userMsg = SymptomChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: symptoms.join(', '),
      isUser: true,
      timestamp: DateTime.now(),
    );

    final loadingMsg = SymptomChatMessage(
      id: 'loading',
      content: '',
      isUser: false,
      timestamp: DateTime.now(),
      type: ChatMessageType.loading,
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg, loadingMsg],
      isLoading: true,
    );

    final result = await ref.read(medicalServicesRepositoryProvider).analyzeSymptoms(
      symptoms,
      additionalInfo: additionalInfo,
    );

    result.when(
      success: (data) {
        final analysis = SymptomAnalysisResult.fromJson(data);
        final diagnosisMsg = SymptomChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: analysis.description,
          isUser: false,
          timestamp: DateTime.now(),
          type: ChatMessageType.diagnosis,
          diagnosis: analysis.diagnosis,
          suggestedMedicines: analysis.suggestedMedicines,
        );

        final updatedMessages = state.messages.where((m) => m.id != 'loading').toList();
        state = state.copyWith(
          messages: [...updatedMessages, diagnosisMsg],
          isLoading: false,
        );
      },
      failure: (error) {
        final errorMsg = SymptomChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: 'عذراً، حدث خطأ أثناء التحليل. حاول تاني.',
          isUser: false,
          timestamp: DateTime.now(),
        );
        final updatedMessages = state.messages.where((m) => m.id != 'loading').toList();
        state = state.copyWith(
          messages: [...updatedMessages, errorMsg],
          isLoading: false,
          error: error,
        );
      },
    );
  }

  void resetChat() {
    state = const SymptomChatState();
    _initChat();
  }
}

// ─── Medication Reminders Provider ─────────────────────────────

final medicationRemindersProvider =
    AsyncNotifierProvider<MedicationRemindersViewModel, List<MedicationReminderModel>>(
  MedicationRemindersViewModel.new,
);

class MedicationRemindersViewModel extends AsyncNotifier<List<MedicationReminderModel>> {
  static const String _storageKey = 'webstore_medication_reminders';

  @override
  Future<List<MedicationReminderModel>> build() async {
    List<MedicationReminderModel> reminders = [];
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final jsonString = prefs.getString(_storageKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        reminders = jsonList
            .map((item) => MedicationReminderModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      }
    } catch (e) {
      print('[Reminder] ERROR loading reminders from SharedPreferences: $e');
    }

    print('[Reminder] build(): loaded ${reminders.length} reminder(s) from storage: '
        '${reminders.map((r) => 'id=${r.id} name=${r.medicationName} active=${r.isActive} times=${r.times}').toList()}');

    // Re-schedule all active reminders after app restart
    for (final reminder in reminders.where((r) => r.isActive)) {
      print('[Reminder] build(): re-scheduling after restart for id=${reminder.id}');
      await _scheduleDailyNotificationsForReminder(reminder);
    }

    return reminders;
  }

  Future<void> _saveToStorage(List<MedicationReminderModel> items) async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final jsonList = items.map((e) => e.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));
      print('[Reminder] _saveToStorage: saved ${items.length} item(s) to key "$_storageKey"');
    } catch (e) {
      print('[Reminder] ERROR saving reminders to SharedPreferences: $e');
    }
  }

  static const int _addConfirmationIdBase = 10000000;
  static const int _takenConfirmationIdBase = 11000000;

  int _notificationIdForSlot(int reminderId, int slotIndex) {
    return reminderId * 100 + slotIndex;
  }

  Future<void> _scheduleDailyNotificationsForReminder(MedicationReminderModel reminder) async {
    print('[Reminder] Scheduling ${reminder.times.length} daily notification(s) '
        'for reminder id=${reminder.id} name="${reminder.medicationName}" times=${reminder.times}');
    for (var i = 0; i < reminder.times.length; i++) {
      final timeStr = reminder.times[i];
      final parts = timeStr.split(':');
      if (parts.length < 2) {
        print('[Reminder] slot $i SKIPPED: invalid time string "$timeStr"');
        continue;
      }
      final hour = int.tryParse(parts[0]) ?? 8;
      final minute = int.tryParse(parts[1]) ?? 0;
      // Unique notification ID per reminder + time slot index
      final notifId = _notificationIdForSlot(reminder.id, i);
      print('[Reminder] slot $i -> notifId=$notifId time=$timeStr parsed hour=$hour minute=$minute');
      await LocalNotificationService().scheduleDailyNotification(
        id: notifId,
        title: '⏰ موعد دواء: ${reminder.medicationName}',
        body: 'حان وقت أخذ جرعة ${reminder.medicationName} (${reminder.dosage})',
        hour: hour,
        minute: minute,
        payload: '${reminder.id}',
      );
    }
  }

  void _cancelAllNotificationsForReminder(MedicationReminderModel reminder) {
    for (var i = 0; i < reminder.times.length; i++) {
      LocalNotificationService().cancelNotification(
        _notificationIdForSlot(reminder.id, i),
      );
    }
    // Also cancel confirm notifications
    LocalNotificationService().cancelNotification(
      _addConfirmationIdBase + reminder.id,
    );
    LocalNotificationService().cancelNotification(
      _takenConfirmationIdBase + reminder.id,
    );
  }

  Future<void> addReminder(Map<String, dynamic> data) async {
    print('[Reminder] ========== ADD REMINDER START ==========');
    print('[Reminder] received data: $data');
    final newId = (DateTime.now().millisecondsSinceEpoch % 100000);
    final times = List<String>.from(data['times'] ?? ['08:00']);

    final newReminder = MedicationReminderModel(
      id: newId,
      medicationName: data['medication_name'] ?? 'دواء جديد',
      dosage: data['dosage'] ?? 'جرعة واحدة',
      frequency: data['frequency'] ?? 'يومياً',
      times: times,
      startDate: DateTime.tryParse(data['start_date'] ?? '') ?? DateTime.now(),
      isActive: true,
      notes: data['notes'],
      logs: const [],
    );
    print('[Reminder] new id=$newId name="${newReminder.medicationName}" '
        'dosage="${newReminder.dosage}" frequency="${newReminder.frequency}" '
        'times=$times startDate=${newReminder.startDate.toIso8601String()}');

    final currentList = state.value ?? [];
    final updatedList = [newReminder, ...currentList];
    print('[Reminder] total reminders in storage after add: ${updatedList.length}');

    state = AsyncValue.data(updatedList);
    await _saveToStorage(updatedList);
    print('[Reminder] saved to SharedPreferences (key: $_storageKey)');

    // Request notification permission (Android 13+) and exact alarm access
    // (Android 12+) in this user-action context.
    print('[Reminder] requesting notification permissions...');
    await LocalNotificationService().requestPermissionsForReminders();
    print('[Reminder] permission requests done');

    // Schedule daily recurring notifications for each time slot
    await _scheduleDailyNotificationsForReminder(newReminder);

    // Also show an immediate confirmation notification
    final confirmId = _addConfirmationIdBase + newId;
    print('[Reminder] showing add confirmation notification id=$confirmId '
        'title="✅ تم إضافة تذكير: ${newReminder.medicationName}" '
        'body="ستصلك تنبيهات يومية في: ${newReminder.times.join(' - ')}"');
    await LocalNotificationService().showNotification(
      id: confirmId,
      title: '✅ تم إضافة تذكير: ${newReminder.medicationName}',
      body: 'ستصلك تنبيهات يومية في: ${newReminder.times.join(' - ')}',
    );
    print('[Reminder] ========== ADD REMINDER DONE ==========');
  }

  Future<void> deleteReminder(int id) async {
    print('[Reminder] DELETE reminder id=$id');
    final currentList = state.value ?? [];
    final reminder = currentList.where((r) => r.id == id).firstOrNull;
    final updatedList = currentList.where((r) => r.id != id).toList();

    state = AsyncValue.data(updatedList);
    await _saveToStorage(updatedList);

    // Cancel all daily notifications for every time slot of this reminder
    if (reminder != null) {
      print('[Reminder] DELETE: cancelling notifications for id=$id (${reminder.times.length} slot(s))');
      _cancelAllNotificationsForReminder(reminder);
    } else {
      print('[Reminder] DELETE: reminder id=$id not found in list');
    }
  }

  Future<void> markTaken(int id) async {
    final currentList = state.value ?? [];
    final updatedList = currentList.map((reminder) {
      if (reminder.id == id) {
        final newLog = ReminderLog(
          id: DateTime.now().millisecondsSinceEpoch,
          scheduledTime: DateTime.now(),
          takenAt: DateTime.now(),
          taken: true,
        );
        final updatedLogs = [newLog, ...reminder.logs];
        return MedicationReminderModel(
          id: reminder.id,
          medicationName: reminder.medicationName,
          dosage: reminder.dosage,
          frequency: reminder.frequency,
          times: reminder.times,
          startDate: reminder.startDate,
          endDate: reminder.endDate,
          isActive: reminder.isActive,
          notes: reminder.notes,
          logs: updatedLogs,
        );
      }
      return reminder;
    }).toList();

    state = AsyncValue.data(updatedList);
    await _saveToStorage(updatedList);

    try {
      final reminder = updatedList.firstWhere((r) => r.id == id);
      print('[Reminder] MARK TAKEN id=$id name="${reminder.medicationName}" '
          'confirmationId=${_takenConfirmationIdBase + id} '
          'adherenceRate=${(reminder.adherenceRate * 100).toInt()}%');
      LocalNotificationService().showNotification(
        id: _takenConfirmationIdBase + id,
        title: 'تم تسجيل أخذ الجرعة 👏',
        body: 'تم أخذ جرعة ${reminder.medicationName} بنجاح! نسبة الالتزام الحالية: ${(reminder.adherenceRate * 100).toInt()}%',
      );
    } catch (e) {
      print('[Reminder] MARK TAKEN ERROR: reminder id=$id not found -> $e');
    }
  }

  Future<void> toggleActive(int id) async {
    final currentList = state.value ?? [];
    final updatedList = currentList.map((reminder) {
      if (reminder.id == id) {
        return MedicationReminderModel(
          id: reminder.id,
          medicationName: reminder.medicationName,
          dosage: reminder.dosage,
          frequency: reminder.frequency,
          times: reminder.times,
          startDate: reminder.startDate,
          endDate: reminder.endDate,
          isActive: !reminder.isActive,
          notes: reminder.notes,
          logs: reminder.logs,
        );
      }
      return reminder;
    }).toList();

    state = AsyncValue.data(updatedList);
    await _saveToStorage(updatedList);

    final reminder = updatedList.where((r) => r.id == id).firstOrNull;
    if (reminder == null) {
      print('[Reminder] TOGGLE ACTIVE: id=$id not found');
      return;
    }
    print('[Reminder] TOGGLE ACTIVE id=$id -> isActive=${reminder.isActive}');
    if (reminder.isActive) {
      // Re-schedule daily notifications when re-activated
      await _scheduleDailyNotificationsForReminder(reminder);
    } else {
      // Stop all notifications when deactivated
      _cancelAllNotificationsForReminder(reminder);
    }
  }
}

// ─── AI Scan Provider ──────────────────────────────────────────

final aiScanProvider = NotifierProvider<AiScanViewModel, AiScanState>(
  AiScanViewModel.new,
);

class AiScanState {
  final AiScanResultModel? result;
  final bool isScanning;
  final String? error;
  final String? selectedScanType;

  const AiScanState({
    this.result,
    this.isScanning = false,
    this.error,
    this.selectedScanType,
  });

  AiScanState copyWith({
    AiScanResultModel? result,
    bool? isScanning,
    String? error,
    String? selectedScanType,
  }) {
    return AiScanState(
      result: result ?? this.result,
      isScanning: isScanning ?? this.isScanning,
      error: error,
      selectedScanType: selectedScanType ?? this.selectedScanType,
    );
  }
}

class AiScanViewModel extends Notifier<AiScanState> {
  @override
  AiScanState build() => const AiScanState();

  void setScanType(String type) {
    state = state.copyWith(selectedScanType: type);
  }

  Future<void> performScan(String imagePath) async {
    state = state.copyWith(isScanning: true, error: null);

    final result = await ref.read(medicalServicesRepositoryProvider).scanImage(
      imagePath,
      state.selectedScanType ?? 'general',
    );

    result.when(
      success: (data) {
        state = state.copyWith(
          result: AiScanResultModel.fromJson(data),
          isScanning: false,
        );
      },
      failure: (error) {
        state = state.copyWith(isScanning: false, error: error);
      },
    );
  }

  void reset() {
    state = const AiScanState();
  }
}

// ─── Health Predictions Provider ───────────────────────────────

final healthPredictionsProvider = AsyncNotifierProvider<HealthPredictionsViewModel, List<HealthPrediction>>(
  HealthPredictionsViewModel.new,
);

class HealthPredictionsViewModel extends AsyncNotifier<List<HealthPrediction>> {
  @override
  Future<List<HealthPrediction>> build() async {
    final result = await ref.read(medicalServicesRepositoryProvider).getHealthPredictions();
    return result.when(
      success: (data) => data.map((p) => HealthPrediction.fromJson(p)).toList(),
      failure: (_) => [],
    );
  }
}

// ─── Gamification Provider ─────────────────────────────────────

final gamificationProvider = AsyncNotifierProvider<GamificationViewModel, GamificationData?>(
  GamificationViewModel.new,
);

class GamificationData {
  final int totalPoints;
  final int level;
  final String title;
  final List<Achievement> achievements;
  final List<HealthChallenge> challenges;
  final int streak;

  const GamificationData({
    required this.totalPoints,
    required this.level,
    required this.title,
    required this.achievements,
    required this.challenges,
    required this.streak,
  });

  factory GamificationData.fromJson(Map<String, dynamic> json) {
    return GamificationData(
      totalPoints: json['total_points'] ?? 0,
      level: json['level'] ?? 1,
      title: json['title'] ?? 'مبتدئ صحي',
      achievements: (json['achievements'] as List<dynamic>?)
              ?.map((a) => Achievement.fromJson(a))
              .toList() ??
          [],
      challenges: (json['challenges'] as List<dynamic>?)
              ?.map((c) => HealthChallenge.fromJson(c))
              .toList() ??
          [],
      streak: json['streak'] ?? 0,
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      isUnlocked: json['is_unlocked'] ?? false,
      unlockedAt: json['unlocked_at'] != null ? DateTime.tryParse(json['unlocked_at']) : null,
    );
  }
}

class HealthChallenge {
  final String id;
  final String title;
  final String description;
  final int targetDays;
  final int completedDays;
  final int rewardPoints;

  const HealthChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDays,
    required this.completedDays,
    required this.rewardPoints,
  });

  factory HealthChallenge.fromJson(Map<String, dynamic> json) {
    return HealthChallenge(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      targetDays: json['target_days'] ?? 7,
      completedDays: json['completed_days'] ?? 0,
      rewardPoints: json['reward_points'] ?? 0,
    );
  }

  double get progress => targetDays > 0 ? completedDays / targetDays : 0;
}

class GamificationViewModel extends AsyncNotifier<GamificationData?> {
  @override
  Future<GamificationData?> build() async {
    final result = await ref.read(medicalServicesRepositoryProvider).getGamificationData();
    return result.when(
      success: (data) => GamificationData.fromJson(data),
      failure: (_) => null,
    );
  }
}

// ─── Telemedicine Provider ─────────────────────────────────────

final telemedicineDoctorsProvider =
    AsyncNotifierProvider<TelemedicineViewModel, List<TelemedicineDoctor>>(
  TelemedicineViewModel.new,
);

class TelemedicineDoctor {
  final int id;
  final String name;
  final String specialty;
  final String? avatar;
  final double rating;
  final bool isAvailable;
  final double consultationFee;

  const TelemedicineDoctor({
    required this.id,
    required this.name,
    required this.specialty,
    this.avatar,
    required this.rating,
    this.isAvailable = false,
    required this.consultationFee,
  });

  factory TelemedicineDoctor.fromJson(Map<String, dynamic> json) {
    return TelemedicineDoctor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      avatar: json['avatar'],
      rating: (json['rating'] ?? 0).toDouble(),
      isAvailable: json['is_available'] ?? false,
      consultationFee: (json['consultation_fee'] ?? 0).toDouble(),
    );
  }
}

class TelemedicineViewModel extends AsyncNotifier<List<TelemedicineDoctor>> {
  @override
  Future<List<TelemedicineDoctor>> build() async {
    final result = await ref.read(medicalServicesRepositoryProvider).getTelemedicineDoctors();
    return result.when(
      success: (data) => data.map((d) => TelemedicineDoctor.fromJson(d)).toList(),
      failure: (_) => [],
    );
  }

  Future<void> filterBySpecialty(String? specialty) async {
    state = const AsyncValue.loading();
    final result = await ref.read(medicalServicesRepositoryProvider).getTelemedicineDoctors(
      specialty: specialty,
    );
    state = result.when(
      success: (data) => AsyncValue.data(
        data.map((d) => TelemedicineDoctor.fromJson(d)).toList(),
      ),
      failure: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}

// ─── Daily Activities Provider ────────────────────────────────

final dailyActivitiesProvider =
    AsyncNotifierProvider<DailyActivitiesViewModel, Map<String, DailyActivity>>(
  DailyActivitiesViewModel.new,
);

class DailyActivitiesViewModel extends AsyncNotifier<Map<String, DailyActivity>> {
  @override
  Future<Map<String, DailyActivity>> build() async {
    final result = await ref.read(medicalServicesRepositoryProvider).getDailyActivities();
    return result.when(
      success: (data) {
        final activities = <String, DailyActivity>{};
        final colorMap = {
          'steps': 0xFF4CAF50,
          'water': 0xFF2196F3,
          'sleep': 0xFF9C27B0,
          'calories': 0xFFFF9800,
        };
        final iconMap = {
          'steps': '🚶',
          'water': '💧',
          'sleep': '😴',
          'calories': '🔥',
        };
        final labelMap = {
          'steps': 'المشي',
          'water': 'المية',
          'sleep': 'النوم',
          'calories': 'السعرات',
        };
        data.forEach((key, value) {
          if (value is Map) {
            activities[key] = DailyActivity(
              type: key,
              label: labelMap[key] ?? key,
              currentValue: (value['current'] ?? 0).toDouble(),
              targetValue: (value['target'] ?? 0).toDouble(),
              unit: value['unit'] ?? '',
              icon: iconMap[key] ?? '📊',
              colorValue: colorMap[key] ?? 0xFF6C63FF,
            );
          }
        });
        return activities;
      },
      failure: (_) => <String, DailyActivity>{},
    );
  }

  Future<void> addValue(String type, double value) async {
    final current = state.value;
    if (current == null || !current.containsKey(type)) return;

    final activity = current[type]!;
    final updated = activity.copyWith(currentValue: activity.currentValue + value);

    state = AsyncData({...current, type: updated});

    await ref.read(medicalServicesRepositoryProvider).updateDailyActivity(type, updated.currentValue);
  }

  void updateLocal(String type, double value) {
    final current = state.value;
    if (current == null || !current.containsKey(type)) return;

    final activity = current[type]!;
    final updated = activity.copyWith(currentValue: value);
    state = AsyncData({...current, type: updated});
  }
}

// ─── Computed Achievements (auto-calculated from real data) ──

final computedAchievementsProvider = Provider<List<ComputedAchievement>>((ref) {
  final activities = ref.watch(dailyActivitiesProvider);
  final gamification = ref.watch(gamificationProvider);
  final metrics = ref.watch(healthMetricsProvider);

  final achievements = <ComputedAchievement>[];

  final acts = activities.value ?? {};
  final gamData = gamification.value;
  final metricList = metrics.value ?? [];

  // ─── Activity-based achievements ───────────────────────────
  final hasAnyActivity = acts.isNotEmpty && acts.values.any((a) => a.currentValue > 0);
  final steps = acts['steps'];
  final water = acts['water'];
  final sleep = acts['sleep'];

  achievements.add(ComputedAchievement(
    id: 'first_step',
    title: 'أول نشاط',
    description: 'سجّل أول نشاط صحي',
    icon: '🎯',
    isUnlocked: hasAnyActivity,
    category: AchievementCategory.daily,
  ));

  achievements.add(ComputedAchievement(
    id: 'water_8',
    title: 'شرب كفاية',
    description: 'اشرب 8 كوبايات مية في يوم',
    icon: '💧',
    isUnlocked: water != null && water.currentValue >= water.targetValue,
    category: AchievementCategory.daily,
  ));

  achievements.add(ComputedAchievement(
    id: 'steps_10k',
    title: 'محارب الخطوات',
    description: 'امشي 10,000 خطوة في يوم',
    icon: '👟',
    isUnlocked: steps != null && steps.currentValue >= steps.targetValue,
    category: AchievementCategory.daily,
  ));

  achievements.add(ComputedAchievement(
    id: 'sleep_well',
    title: 'نوم صحي',
    description: 'نام 8 ساعات على الأقل',
    icon: '😴',
    isUnlocked: sleep != null && sleep.currentValue >= sleep.targetValue,
    category: AchievementCategory.daily,
  ));

  achievements.add(ComputedAchievement(
    id: 'all_done',
    title: 'محارب اليوم',
    description: 'أكمل كل النشاطات اليومية',
    icon: '🏆',
    isUnlocked: acts.isNotEmpty && acts.values.every((a) => a.isCompleted),
    category: AchievementCategory.daily,
  ));

  // ─── Streak-based achievements ─────────────────────────────
  final streak = gamData?.streak ?? 0;

  achievements.add(ComputedAchievement(
    id: 'streak_3',
    title: 'سلسلة 3 أيام',
    description: '3 أيام متتالية فيها نشاط',
    icon: '🔥',
    isUnlocked: streak >= 3,
    category: AchievementCategory.streak,
  ));

  achievements.add(ComputedAchievement(
    id: 'streak_7',
    title: 'سلسلة 7 أيام',
    description: '7 أيام متتالية فيها نشاط',
    icon: '⚡',
    isUnlocked: streak >= 7,
    category: AchievementCategory.streak,
  ));

  achievements.add(ComputedAchievement(
    id: 'streak_30',
    title: 'محارب 30 يوم',
    description: '30 يوم متتالي فيها نشاط',
    icon: '👑',
    isUnlocked: streak >= 30,
    category: AchievementCategory.streak,
  ));

  // ─── Health-based achievements ─────────────────────────────
  achievements.add(ComputedAchievement(
    id: 'first_metric',
    title: 'أول قياس',
    description: 'سجّل أول قياس صحي',
    icon: '📸',
    isUnlocked: metricList.isNotEmpty,
    category: AchievementCategory.health,
  ));

  achievements.add(ComputedAchievement(
    id: 'all_normal',
    title: 'صحة ممتازة',
    description: 'كل المقياسات ضمن الطبيعي',
    icon: '💚',
    isUnlocked: metricList.isNotEmpty &&
        metricList.every((m) => m.healthStatus == HealthStatus.normal),
    category: AchievementCategory.health,
  ));

  // ─── Points-based achievements ─────────────────────────────
  final points = gamData?.totalPoints ?? 0;

  achievements.add(ComputedAchievement(
    id: 'points_500',
    title: 'نجم صاعد',
    description: 'اجمع 500 نقطة',
    icon: '⭐',
    isUnlocked: points >= 500,
    category: AchievementCategory.points,
  ));

  achievements.add(ComputedAchievement(
    id: 'points_1000',
    title: 'محترف صحي',
    description: 'اجمع 1000 نقطة',
    icon: '🌟',
    isUnlocked: points >= 1000,
    category: AchievementCategory.points,
  ));

  return achievements;
});

enum AchievementCategory { daily, streak, health, points }

class ComputedAchievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final AchievementCategory category;

  const ComputedAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    required this.category,
  });

  int get unlockedCount => isUnlocked ? 1 : 0;
}
