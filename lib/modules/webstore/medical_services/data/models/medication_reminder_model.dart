
// ─── Dose Units ────────────────────────────────────────────────

/// وحدة الجرعة — units marked [isFractional] support quarters/halves
/// (أقراص/كبسولات), others are measured in plain numbers.
enum DoseUnit {
  pill('قرص', 'أقراص', 'قرصان', isFractional: true),
  capsule('كبسولة', 'كبسولات', 'كبسولتان', isFractional: true),
  mg('ملجم', 'ملجم', 'ملجم'),
  ml('مل', 'مل', 'مل'),
  drop('نقطة', 'نقط', 'نقطتان'),
  injection('حقنة', 'حقن', 'حقنتان'),
  sachet('كيس', 'أكياس', 'كيسان'),
  spoon('ملعقة', 'ملاعق', 'ملعقتان'),
  puff('بخة', 'بخات', 'بختان'),
  patch('لاصقة', 'لاصقات', 'لاصقتان'),
  suppository('تحميلة', 'تحاميل', 'تحميلتان');

  const DoseUnit(this.singular, this.plural, this.dual, {this.isFractional = false});

  final String singular;
  final String plural;
  final String dual;
  final bool isFractional;

  static DoseUnit? fromName(String? name) {
    for (final unit in DoseUnit.values) {
      if (unit.name == name) return unit;
    }
    return null;
  }
}

// ─── Administration Methods ────────────────────────────────────

/// طريقة أخذ الجرعة (مهمة جداً لأدوية الكبد والمعدة وغيرهما).
enum AdministrationMethod {
  beforeMeal('قبل الأكل'),
  afterMeal('بعد الأكل'),
  withMeal('مع الأكل'),
  emptyStomach('على معدة فارغة'),
  beforeBed('قبل النوم'),
  uponWaking('عند الاستيقاظ'),
  sublingual('تحت اللسان'),
  oral('عن طريق الفم'),
  intramuscular('حقن عضلي'),
  subcutaneous('حقن تحت الجلد'),
  inhalation('استنشاق'),
  topical('على الجلد'),
  eyeEarDrops('قطرات عين/أذن'),
  nasal('بخاخ أنف'),
  vaginal('مهبلي'),
  asDirected('حسب تعليمات الطبيب');

  const AdministrationMethod(this.label);

  final String label;

  static AdministrationMethod? fromName(String? name) {
    for (final method in AdministrationMethod.values) {
      if (method.name == name) return method;
    }
    return null;
  }
}

// ─── Dose Amount ───────────────────────────────────────────────

/// جرعة منظمة: رقم + وحدة (مثال: 0.5 قرص = نص قرص، 250 ملجم).
class DoseAmount {
  final double amount;
  final DoseUnit unit;

  const DoseAmount({required this.amount, required this.unit});

  factory DoseAmount.fromJson(Map<String, dynamic> json) {
    return DoseAmount(
      amount: (json['amount'] as num?)?.toDouble() ?? 1,
      unit: DoseUnit.fromName(json['unit']) ?? DoseUnit.pill,
    );
  }

  Map<String, dynamic> toJson() => {'amount': amount, 'unit': unit.name};

  /// التسمية العربية للجرعة: "نص قرص" / "قرص ونص" / "250 ملجم" ...
  String get displayLabel {
    if (amount <= 0) return 'بدون جرعة';

    if (!unit.isFractional) {
      return '${_formatNumber(amount)} ${unit.singular}';
    }

    final whole = amount.truncate();
    final quarters = (amount * 4).round() % 4; // 0,1,2,3
    final unitName = unit.singular;

    if (whole == 0) {
      switch (quarters) {
        case 1:
          return 'ربع $unitName';
        case 2:
          return 'نصف $unitName';
        case 3:
          return 'ثلاثة أرباع $unitName';
        default:
          return 'بدون جرعة';
      }
    }

    if (quarters == 0) {
      if (whole == 1) return '$unitName واحد';
      if (whole == 2) return unit.dual;
      return '$whole ${unit.plural}';
    }

    final fractionWord = switch (quarters) {
      1 => 'وربع',
      2 => 'ونص',
      3 => 'وثلاثة أرباع',
      _ => '',
    };

    if (whole == 1) return '$unitName $fractionWord';
    if (whole == 2) return '${unit.dual} $fractionWord';
    return '$whole ${unit.plural} $fractionWord';
  }

  static String _formatNumber(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    final text = value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
    return text;
  }

  @override
  bool operator ==(Object other) =>
      other is DoseAmount && other.amount == amount && other.unit == unit;

  @override
  int get hashCode => Object.hash(amount, unit);
}

// ─── Time Slot ─────────────────────────────────────────────────

/// موعد واحد داخل يوم معين: وقت + جرعة + طريقة أخذ.
class MedicationTimeSlot {
  final int hour;
  final int minute;
  final DoseAmount dose;
  final AdministrationMethod method;

  const MedicationTimeSlot({
    required this.hour,
    required this.minute,
    required this.dose,
    required this.method,
  });

  factory MedicationTimeSlot.fromJson(Map<String, dynamic> json) {
    return MedicationTimeSlot(
      hour: (json['hour'] as num?)?.toInt() ?? 8,
      minute: (json['minute'] as num?)?.toInt() ?? 0,
      dose: DoseAmount.fromJson(Map<String, dynamic>.from(json['dose'] ?? {})),
      method: AdministrationMethod.fromName(json['method']) ?? AdministrationMethod.afterMeal,
    );
  }

  Map<String, dynamic> toJson() => {
        'hour': hour,
        'minute': minute,
        'dose': dose.toJson(),
        'method': method.name,
      };

  String get timeLabel {
    final h12 = hour % 12 == 0 ? 12 : hour % 12;
    final minuteStr = minute.toString().padLeft(2, '0');
    final period = hour < 12 ? 'صباحاً' : 'مساءً';
    return '$h12:$minuteStr $period';
  }

  DateTime nextOccurrenceOn(DateTime day) {
    return DateTime(day.year, day.month, day.day, hour, minute);
  }
}

// ─── Day Schedule ──────────────────────────────────────────────

/// جدول يوم واحد في الأسبوع (weekday حسب DateTime: 1=الاثنين .. 7=الأحد).
class PlanDaySchedule {
  final int weekday;
  final List<MedicationTimeSlot> slots;

  const PlanDaySchedule({required this.weekday, this.slots = const []});

  factory PlanDaySchedule.fromJson(Map<String, dynamic> json) {
    return PlanDaySchedule(
      weekday: (json['weekday'] as num?)?.toInt() ?? DateTime.monday,
      slots: (json['slots'] as List<dynamic>?)
              ?.map((s) => MedicationTimeSlot.fromJson(Map<String, dynamic>.from(s as Map)))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'weekday': weekday,
        'slots': slots.map((s) => s.toJson()).toList(),
      };

  static const List<int> weekOrder = [
    DateTime.saturday,
    DateTime.sunday,
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
  ];

  static String weekdayLabel(int weekday) {
    return switch (weekday) {
      DateTime.saturday => 'السبت',
      DateTime.sunday => 'الأحد',
      DateTime.monday => 'الاثنين',
      DateTime.tuesday => 'الثلاثاء',
      DateTime.wednesday => 'الأربعاء',
      DateTime.thursday => 'الخميس',
      DateTime.friday => 'الجمعة',
      _ => '',
    };
  }

  static String weekdayShortLabel(int weekday) {
    return switch (weekday) {
      DateTime.saturday => 'سبت',
      DateTime.sunday => 'أحد',
      DateTime.monday => 'اثنين',
      DateTime.tuesday => 'ثلاثاء',
      DateTime.wednesday => 'أربعاء',
      DateTime.thursday => 'خميس',
      DateTime.friday => 'جمعة',
      _ => '',
    };
  }
}

// ─── Reminder Model ────────────────────────────────────────────

class MedicationReminderModel {
  static const int schemaVersion = 2;

  final int id;
  final String medicationName;
  final String? conditionName; // الخطة/الحالة (مثال: ضغط الدم)
  final String? notes;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final List<PlanDaySchedule> weeklySchedule; // 7 أيام — النمط الأسبوعي المتكرر
  final List<ReminderLog> logs;

  const MedicationReminderModel({
    required this.id,
    required this.medicationName,
    this.conditionName,
    this.notes,
    required this.startDate,
    this.endDate,
    this.isActive = true,
    required this.weeklySchedule,
    this.logs = const [],
  });

  factory MedicationReminderModel.fromJson(Map<String, dynamic> json) {
    if (json['weekly_schedule'] is List) {
      return MedicationReminderModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        medicationName: json['medication_name'] ?? '',
        conditionName: json['condition_name'],
        notes: json['notes'],
        startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
        endDate: json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
        isActive: json['is_active'] ?? true,
        weeklySchedule: (json['weekly_schedule'] as List<dynamic>)
            .map((d) => PlanDaySchedule.fromJson(Map<String, dynamic>.from(d as Map)))
            .toList(),
        logs: (json['logs'] as List<dynamic>?)
                ?.map((l) => ReminderLog.fromJson(l))
                .toList() ??
            [],
      );
    }
    return MedicationReminderModel._fromLegacyJson(json);
  }

  /// ترحيل التذكيرات القديمة (اسم + جرعة نصية + times) إلى النظام الجديد.
  factory MedicationReminderModel._fromLegacyJson(Map<String, dynamic> json) {
    final times = List<String>.from(json['times'] ?? const ['08:00']);
    final frequency = (json['frequency'] ?? 'يومياً').toString();
    final dosageText = (json['dosage'] ?? 'قرص واحد').toString();
    final startDate = DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now();

    final days = frequency.contains('أسبوعي')
        ? <int>[startDate.weekday]
        : List.of(PlanDaySchedule.weekOrder);

    final dose = _parseLegacyDose(dosageText);
    final method = _parseLegacyMethod(dosageText);
    final notes = <String>[
      if (json['notes'] != null && (json['notes'] as String).isNotEmpty)
        json['notes'] as String,
      if (!_parsedFully(dosageText)) 'الجرعة الأصلية: $dosageText',
    ].join(' | ');

    final weeklySchedule = days.map((weekday) {
      return PlanDaySchedule(
        weekday: weekday,
        slots: times.map((timeStr) {
          final parts = timeStr.split(':');
          return MedicationTimeSlot(
            hour: int.tryParse(parts[0]) ?? 8,
            minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
            dose: dose,
            method: method,
          );
        }).toList(),
      );
    }).toList();

    return MedicationReminderModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      medicationName: json['medication_name'] ?? '',
      notes: notes.isEmpty ? null : notes,
      startDate: startDate,
      endDate: json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      isActive: json['is_active'] ?? true,
      weeklySchedule: weeklySchedule,
      logs: (json['logs'] as List<dynamic>?)
              ?.map((l) => ReminderLog.fromJson(l))
              .toList() ??
          [],
    );
  }

  static bool _parsedFully(String dosageText) {
    return _parseLegacyDose(dosageText).amount == 1 &&
        _parseLegacyDose(dosageText).unit == DoseUnit.pill &&
        !RegExp(r'واحد|قرص', caseSensitive: false).hasMatch(dosageText);
  }

  static DoseAmount _parseLegacyDose(String text) {
    final normalized = text.replaceAll('أ', 'ا').replaceAll('إ', 'ا');
    DoseUnit unit = DoseUnit.pill;
    if (normalized.contains('كبسول')) unit = DoseUnit.capsule;
    if (normalized.contains('ملجم') || normalized.contains('مجم')) unit = DoseUnit.mg;
    if (normalized.contains(' مل') || normalized.contains('سم')) unit = DoseUnit.ml;
    if (normalized.contains('نقط')) unit = DoseUnit.drop;
    if (normalized.contains('حقن') || normalized.contains('امبول')) unit = DoseUnit.injection;
    if (normalized.contains('كيس')) unit = DoseUnit.sachet;
    if (normalized.contains('ملعق')) unit = DoseUnit.spoon;
    if (normalized.contains('بخ')) unit = DoseUnit.puff;
    if (normalized.contains('لاصق')) unit = DoseUnit.patch;
    if (normalized.contains('تحميل')) unit = DoseUnit.suppository;

    double amount = 1;
    if (normalized.contains('ثلاثة ارباع')) {
      amount = 0.75;
    } else if (normalized.contains('نصف') || normalized.contains('نص قرص')) {
      amount = 0.5;
    } else if (normalized.contains('ربع')) {
      amount = 0.25;
    } else if (normalized.contains('ونص') || normalized.contains(' ونصف')) {
      amount = 1.5;
    } else if (normalized.contains('قرصين') || normalized.contains('كبسولتين') ||
        normalized.contains('اثنين') || normalized.contains('اثنان')) {
      amount = 2;
    } else {
      final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(normalized);
      if (match != null) {
        amount = double.tryParse(match.group(1)!) ?? 1;
      }
    }
    if (amount <= 0) amount = 1;

    return DoseAmount(amount: amount, unit: unit);
  }

  static AdministrationMethod _parseLegacyMethod(String text) {
    final normalized = text.replaceAll('أ', 'ا').replaceAll('إ', 'ا');
    if (normalized.contains('قبل النوم')) return AdministrationMethod.beforeBed;
    if (normalized.contains('معدة فارغة')) return AdministrationMethod.emptyStomach;
    if (normalized.contains('قبل الاكل')) return AdministrationMethod.beforeMeal;
    if (normalized.contains('مع الاكل') || normalized.contains('مع اكل')) {
      return AdministrationMethod.withMeal;
    }
    if (normalized.contains('بعد الاكل')) return AdministrationMethod.afterMeal;
    return AdministrationMethod.oral;
  }

  Map<String, dynamic> toJson() {
    return {
      'schema_version': schemaVersion,
      'id': id,
      'medication_name': medicationName,
      'condition_name': conditionName,
      'notes': notes,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive,
      'weekly_schedule': weeklySchedule.map((d) => d.toJson()).toList(),
      'logs': logs.map((l) => l.toJson()).toList(),
    };
  }

  // ─── Helpers ─────────────────────────────────────────────

  List<MedicationTimeSlot> slotsFor(int weekday) {
    for (final day in weeklySchedule) {
      if (day.weekday == weekday) return day.slots;
    }
    return const [];
  }

  int get totalWeeklySlots => weeklySchedule.fold(0, (sum, d) => sum + d.slots.length);

  List<int> get scheduledWeekdays =>
      weeklySchedule.where((d) => d.slots.isNotEmpty).map((d) => d.weekday).toList();

  bool get isTodayScheduled {
    final now = DateTime.now();
    if (startDate.isAfter(DateTime(now.year, now.month, now.day))) return false;
    if (endDate != null && endDate!.isBefore(DateTime(now.year, now.month, now.day))) return false;
    return slotsFor(now.weekday).isNotEmpty;
  }

  /// هل الجرعة الخاصة بهذا الموعد (التاريخ المحدد) اتسجلت كمتاخدة؟
  bool isTakenOn(DateTime occurrence) {
    for (final log in logs) {
      if (!log.taken || log.scheduledTime == null) continue;
      if (log.scheduledTime!.difference(occurrence).inMinutes.abs() <= 1) return true;
    }
    return false;
  }

  /// نسبة الالتزام منذ تاريخ البدء حتى اليوم (أو نهاية الخطة).
  double get adherenceRate {
    final takenCount = logs.where((l) => l.taken).length;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = endDate == null
        ? todayDate
        : DateTime(endDate!.year, endDate!.month, endDate!.day).isBefore(todayDate)
            ? DateTime(endDate!.year, endDate!.month, endDate!.day)
            : todayDate;

    int expected = 0;
    var cursor = start;
    while (!cursor.isAfter(end)) {
      expected += slotsFor(cursor.weekday).length;
      cursor = cursor.add(const Duration(days: 1));
    }

    if (takenCount == 0) return 0.0;
    if (expected <= 0) return 0.0;
    return (takenCount / expected).clamp(0.0, 1.0);
  }

  MedicationReminderModel copyWith({
    String? medicationName,
    String? conditionName,
    String? notes,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    List<PlanDaySchedule>? weeklySchedule,
    List<ReminderLog>? logs,
  }) {
    return MedicationReminderModel(
      id: id,
      medicationName: medicationName ?? this.medicationName,
      conditionName: conditionName ?? this.conditionName,
      notes: notes ?? this.notes,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      weeklySchedule: weeklySchedule ?? this.weeklySchedule,
      logs: logs ?? this.logs,
    );
  }
}

// ─── Reminder Log ──────────────────────────────────────────────

class ReminderLog {
  final int id;
  final DateTime? scheduledTime;
  final DateTime? takenAt;
  final bool taken;

  const ReminderLog({
    required this.id,
    this.scheduledTime,
    this.takenAt,
    this.taken = false,
  });

  factory ReminderLog.fromJson(Map<String, dynamic> json) {
    return ReminderLog(
      id: (json['id'] as num?)?.toInt() ?? 0,
      scheduledTime: json['scheduled_time'] != null
          ? DateTime.tryParse(json['scheduled_time'])
          : null,
      takenAt: json['taken_at'] != null ? DateTime.tryParse(json['taken_at']) : null,
      taken: json['taken'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheduled_time': scheduledTime?.toIso8601String(),
      'taken_at': takenAt?.toIso8601String(),
      'taken': taken,
    };
  }
}
