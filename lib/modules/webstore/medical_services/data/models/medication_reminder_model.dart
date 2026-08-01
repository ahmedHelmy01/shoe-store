import 'dart:math';

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
    final takenCount = logs.where((l) => l.taken).length;
    if (takenCount == 0) return 0.0;

    final daysActive = max(1, DateTime.now().difference(startDate).inDays + 1);
    final dosesPerDay = times.isEmpty ? 1 : times.length;
    final expectedDoses = max(logs.length, daysActive * dosesPerDay);

    return (takenCount / expectedDoses).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medication_name': medicationName,
      'dosage': dosage,
      'frequency': frequency,
      'times': times,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive,
      'notes': notes,
      'logs': logs.map((l) => l.toJson()).toList(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheduled_time': scheduledTime.toIso8601String(),
      'taken_at': takenAt?.toIso8601String(),
      'taken': taken,
    };
  }
}
