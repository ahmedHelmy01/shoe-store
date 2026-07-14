class PointsReportModel {
  final int totalPoints;
  final double totalValue;
  final int customerCount;
  final int transactionCount;
  final List<Map<String, dynamic>> rows;

  const PointsReportModel({
    required this.totalPoints,
    required this.totalValue,
    required this.customerCount,
    required this.transactionCount,
    required this.rows,
  });

  factory PointsReportModel.fromJson(Map<String, dynamic> json) {
    return PointsReportModel(
      totalPoints: json['total_points'] as int? ?? 0,
      totalValue: (json['total_value'] as num?)?.toDouble() ?? 0.0,
      customerCount: json['customer_count'] as int? ??
          json['total_customers'] as int? ??
          0,
      transactionCount: json['transaction_count'] as int? ??
          json['total_transactions'] as int? ??
          0,
      rows: (json['data'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          const [],
    );
  }
}
