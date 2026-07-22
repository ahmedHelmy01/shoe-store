class HealthMetricModel {
  final int id;
  final String type;
  final String label;
  final double value;
  final String unit;
  final DateTime recordedAt;
  final String? status;
  final String? note;

  const HealthMetricModel({
    required this.id,
    required this.type,
    required this.label,
    required this.value,
    required this.unit,
    required this.recordedAt,
    this.status,
    this.note,
  });

  factory HealthMetricModel.fromJson(Map<String, dynamic> json) {
    return HealthMetricModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      label: json['label'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      recordedAt: DateTime.tryParse(json['recorded_at'] ?? '') ?? DateTime.now(),
      status: json['status'],
      note: json['note'],
    );
  }

  HealthStatus get healthStatus {
    if (status == 'critical') return HealthStatus.critical;
    if (status == 'warning') return HealthStatus.warning;
    return HealthStatus.normal;
  }
}

enum HealthStatus { normal, warning, critical }

class HealthProfileModel {
  final int? age;
  final String? gender;
  final double? weight;
  final double? height;
  final String? bloodType;
  final List<String> allergies;
  final List<String> chronicDiseases;
  final List<HealthMetricModel> metrics;

  const HealthProfileModel({
    this.age,
    this.gender,
    this.weight,
    this.height,
    this.bloodType,
    this.allergies = const [],
    this.chronicDiseases = const [],
    this.metrics = const [],
  });

  factory HealthProfileModel.fromJson(Map<String, dynamic> json) {
    return HealthProfileModel(
      age: json['age'],
      gender: json['gender'],
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      bloodType: json['blood_type'],
      allergies: List<String>.from(json['allergies'] ?? []),
      chronicDiseases: List<String>.from(json['chronic_diseases'] ?? []),
      metrics: (json['metrics'] as List<dynamic>?)
              ?.map((m) => HealthMetricModel.fromJson(m))
              .toList() ??
          [],
    );
  }

  double? get bmi {
    if (weight == null || height == null || height == 0) return null;
    final heightM = height! / 100;
    return weight! / (heightM * heightM);
  }
}
