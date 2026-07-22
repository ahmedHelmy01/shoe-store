class MedicationReminderModel {
  final int id;
  final String medicationName;
  final String dosage;
  final String frequency;
  final List<String> times;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? notes;
  final List<ReminderLog> logs;

  const MedicationReminderModel({
    required this.id,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.times,
    required this.startDate,
    this.endDate,
    this.isActive = true,
    this.notes,
    this.logs = const [],
  });

  factory MedicationReminderModel.fromJson(Map<String, dynamic> json) {
    return MedicationReminderModel(
      id: json['id'] ?? 0,
      medicationName: json['medication_name'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      times: List<String>.from(json['times'] ?? []),
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      endDate: json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      isActive: json['is_active'] ?? true,
      notes: json['notes'],
      logs: (json['logs'] as List<dynamic>?)
              ?.map((l) => ReminderLog.fromJson(l))
              .toList() ??
          [],
    );
  }

  double get adherenceRate {
    if (logs.isEmpty) return 1.0;
    final taken = logs.where((l) => l.taken).length;
    return taken / logs.length;
  }
}

class ReminderLog {
  final int id;
  final DateTime scheduledTime;
  final DateTime? takenAt;
  final bool taken;

  const ReminderLog({
    required this.id,
    required this.scheduledTime,
    this.takenAt,
    this.taken = false,
  });

  factory ReminderLog.fromJson(Map<String, dynamic> json) {
    return ReminderLog(
      id: json['id'] ?? 0,
      scheduledTime: DateTime.tryParse(json['scheduled_time'] ?? '') ?? DateTime.now(),
      takenAt: json['taken_at'] != null ? DateTime.tryParse(json['taken_at']) : null,
      taken: json['taken'] ?? false,
    );
  }
}
