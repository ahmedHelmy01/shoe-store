import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/services/local_notification_service.dart';
import 'package:erp/modules/webstore/medical_services/data/models/medication_reminder_model.dart';

/// تذكيرات الأدوية — النمط الأسبوعي المتقدم.
/// التخزين محلي في SharedPreferences + جدولة إشعارات أسبوعية لكل موعد.
final medicationRemindersProvider =
    AsyncNotifierProvider<MedicationRemindersViewModel, List<MedicationReminderModel>>(
  MedicationRemindersViewModel.new,
);

class MedicationRemindersViewModel extends AsyncNotifier<List<MedicationReminderModel>> {
  static const String _storageKey = 'webstore_medication_reminders';

  static const int _addConfirmationIdBase = 10000000;
  static const int _takenConfirmationIdBase = 11000000;

  @override
  Future<List<MedicationReminderModel>> build() async {
    List<MedicationReminderModel> reminders = [];
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final jsonString = prefs.getString(_storageKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        reminders = jsonList
            .map((item) =>
                MedicationReminderModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      }
    } catch (e) {
      print('[Reminder] ERROR loading reminders from SharedPreferences: $e');
    }

    print('[Reminder] build(): loaded ${reminders.length} reminder(s) from storage: '
        '${reminders.map((r) => 'id=${r.id} name=${r.medicationName} active=${r.isActive} '
            'days=${r.scheduledWeekdays} slots=${r.totalWeeklySlots}').toList()}');

    // إعادة جدولة كل التذكيرات النشطة بعد إعادة تشغيل التطبيق
    for (final reminder in reminders.where((r) => r.isActive)) {
      print('[Reminder] build(): re-scheduling after restart for id=${reminder.id}');
      await _scheduleForReminder(reminder);
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

  // ─── Scheduling ────────────────────────────────────────────

  int _notifId(int reminderId, int weekday, int slotIndex) {
    return reminderId * 1000 + weekday * 10 + slotIndex;
  }

  Future<void> _scheduleForReminder(MedicationReminderModel reminder) async {
    print('[Reminder] Scheduling weekly notifications for reminder id=${reminder.id} '
        'name="${reminder.medicationName}" (${reminder.totalWeeklySlots} slot(s))');
    for (final day in reminder.weeklySchedule) {
      for (var i = 0; i < day.slots.length; i++) {
        final slot = day.slots[i];
        final notifId = _notifId(reminder.id, day.weekday, i);
        print('[Reminder] slot weekday=${day.weekday} i=$i -> notifId=$notifId '
            'time=${slot.hour}:${slot.minute} dose="${slot.dose.displayLabel}" '
            'method="${slot.method.label}"');
        await LocalNotificationService().scheduleWeeklyNotification(
          id: notifId,
          title: '⏰ موعد دواء: ${reminder.medicationName}',
          body: 'حان وقت أخذ: ${slot.dose.displayLabel} • ${slot.method.label}',
          weekday: day.weekday,
          hour: slot.hour,
          minute: slot.minute,
          payload: '${reminder.id}',
        );
      }
    }
  }

  Future<void> _cancelForReminder(MedicationReminderModel reminder) async {
    for (final day in reminder.weeklySchedule) {
      for (var i = 0; i < day.slots.length; i++) {
        LocalNotificationService().cancelNotification(
          _notifId(reminder.id, day.weekday, i),
        );
      }
    }
    LocalNotificationService().cancelNotification(_addConfirmationIdBase + reminder.id);
    LocalNotificationService().cancelNotification(_takenConfirmationIdBase + reminder.id);
  }

  // ─── CRUD ──────────────────────────────────────────────────

  Future<void> addReminder(Map<String, dynamic> data) async {
    print('[Reminder] ========== ADD REMINDER START ==========');
    print('[Reminder] received data: $data');
    final newId = (DateTime.now().millisecondsSinceEpoch % 100000) + 1;

    final newReminder = MedicationReminderModel(
      id: newId,
      medicationName: data['medication_name'] ?? 'دواء جديد',
      conditionName: data['condition_name'] as String?,
      notes: data['notes'] as String?,
      startDate: DateTime.tryParse(data['start_date'] ?? '') ?? DateTime.now(),
      endDate: data['end_date'] != null ? DateTime.tryParse(data['end_date']) : null,
      isActive: true,
      weeklySchedule: List<PlanDaySchedule>.from(data['weekly_schedule'] ?? const []),
      logs: const [],
    );
    print('[Reminder] new id=$newId name="${newReminder.medicationName}" '
        'condition="${newReminder.conditionName}" '
        'days=${newReminder.scheduledWeekdays} slots=${newReminder.totalWeeklySlots}');

    final currentList = state.value ?? [];
    final updatedList = [newReminder, ...currentList];

    state = AsyncValue.data(updatedList);
    await _saveToStorage(updatedList);

    await LocalNotificationService().requestPermissionsForReminders();

    await _scheduleForReminder(newReminder);

    final confirmId = _addConfirmationIdBase + newId;
    await LocalNotificationService().showNotification(
      id: confirmId,
      title: '✅ تم إضافة تذكير: ${newReminder.medicationName}',
      body: 'ستصلك تنبيهات أسبوعية لكل موعد محدد بجرعته وطريقة تناوله',
    );
    print('[Reminder] ========== ADD REMINDER DONE ==========');
  }

  Future<void> updateReminder(MedicationReminderModel updated) async {
    print('[Reminder] UPDATE reminder id=${updated.id} name="${updated.medicationName}" '
        'days=${updated.scheduledWeekdays} slots=${updated.totalWeeklySlots}');

    // 1) ألغِ الجدولة القديمة
    final currentList = state.value ?? [];
    final old = currentList.where((r) => r.id == updated.id).firstOrNull;
    if (old != null) await _cancelForReminder(old);

    // 2) احفظ النسخة الجديدة مع الاحتفاظ بالسجل
    final updatedWithLogs = updated.copyWith(logs: old?.logs);
    final newList = currentList.map((r) => r.id == updated.id ? updatedWithLogs : r).toList();
    state = AsyncValue.data(newList);
    await _saveToStorage(newList);

    // 3) أعد الجدولة إن كانت نشطة
    if (updatedWithLogs.isActive) {
      await _scheduleForReminder(updatedWithLogs);
    }
  }

  Future<void> deleteReminder(int id) async {
    print('[Reminder] DELETE reminder id=$id');
    final currentList = state.value ?? [];
    final reminder = currentList.where((r) => r.id == id).firstOrNull;
    final updatedList = currentList.where((r) => r.id != id).toList();

    state = AsyncValue.data(updatedList);
    await _saveToStorage(updatedList);

    if (reminder != null) {
      await _cancelForReminder(reminder);
    }
  }

  Future<void> toggleActive(int id) async {
    final currentList = state.value ?? [];
    final updatedList = currentList.map((r) {
      if (r.id == id) return r.copyWith(isActive: !r.isActive);
      return r;
    }).toList();

    state = AsyncValue.data(updatedList);
    await _saveToStorage(updatedList);

    final updated = updatedList.where((r) => r.id == id).firstOrNull;
    if (updated == null) return;
    print('[Reminder] TOGGLE ACTIVE id=$id -> isActive=${updated.isActive}');
    if (updated.isActive) {
      await _scheduleForReminder(updated);
    } else {
      await _cancelForReminder(updated);
    }
  }

  /// تسجيل أخذ الجرعة لموعد محدد (التاريخ الكامل للموعد الواقعي).
  Future<void> markTaken(int id, {required DateTime scheduledFor}) async {
    final currentList = state.value ?? [];
    final updatedList = currentList.map((reminder) {
      if (reminder.id == id) {
        final newLog = ReminderLog(
          id: DateTime.now().millisecondsSinceEpoch,
          scheduledTime: scheduledFor,
          takenAt: DateTime.now(),
          taken: true,
        );
        return reminder.copyWith(logs: [newLog, ...reminder.logs]);
      }
      return reminder;
    }).toList();

    state = AsyncValue.data(updatedList);
    await _saveToStorage(updatedList);

    try {
      final reminder = updatedList.firstWhere((r) => r.id == id);
      LocalNotificationService().showNotification(
        id: _takenConfirmationIdBase + id,
        title: 'تم تسجيل أخذ الجرعة 👏',
        body: 'تم أخذ جرعة ${reminder.medicationName} بنجاح! '
            'نسبة الالتزام الحالية: ${(reminder.adherenceRate * 100).toInt()}%',
      );
    } catch (e) {
      print('[Reminder] MARK TAKEN ERROR: reminder id=$id not found -> $e');
    }
  }
}
