class AiScanResultModel {
  final String scanType;
  final Map<String, ScanMetric> metrics;
  final String overallStatus;
  final DateTime scannedAt;
  final List<String> recommendations;

  const AiScanResultModel({
    required this.scanType,
    required this.metrics,
    required this.overallStatus,
    required this.scannedAt,
    this.recommendations = const [],
  });

  factory AiScanResultModel.fromJson(Map<String, dynamic> json) {
    return AiScanResultModel(
      scanType: json['scan_type'] ?? '',
      metrics: (json['metrics'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, ScanMetric.fromJson(v)),
          ) ??
          {},
      overallStatus: json['overall_status'] ?? 'normal',
      scannedAt: DateTime.tryParse(json['scanned_at'] ?? '') ?? DateTime.now(),
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }
}

class ScanMetric {
  final String name;
  final double value;
  final String unit;
  final String status;
  final String? description;

  const ScanMetric({
    required this.name,
    required this.value,
    required this.unit,
    required this.status,
    this.description,
  });

  factory ScanMetric.fromJson(Map<String, dynamic> json) {
    return ScanMetric(
      name: json['name'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      status: json['status'] ?? 'normal',
      description: json['description'],
    );
  }
}

class HealthPrediction {
  final String title;
  final String description;
  final double probability;
  final String timeframe;
  final List<String> preventionTips;

  const HealthPrediction({
    required this.title,
    required this.description,
    required this.probability,
    required this.timeframe,
    this.preventionTips = const [],
  });

  factory HealthPrediction.fromJson(Map<String, dynamic> json) {
    return HealthPrediction(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      probability: (json['probability'] ?? 0).toDouble(),
      timeframe: json['timeframe'] ?? '',
      preventionTips: List<String>.from(json['prevention_tips'] ?? []),
    );
  }
}
