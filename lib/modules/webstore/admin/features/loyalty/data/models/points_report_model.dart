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
    final isCostReport = json.containsKey('total_points_awarded');

    if (isCostReport) {
      const labels = {
        'total_points_awarded': 'Total Points Awarded',
        'total_points_redeemed': 'Total Points Redeemed',
        'total_discount_value': 'Total Discount Value',
        'total_points_expired': 'Total Points Expired',
        'estimated_liability': 'Estimated Liability',
      };
      final rows = <Map<String, dynamic>>[];
      for (final entry in json.entries) {
        rows.add({
          'metric': labels[entry.key] ?? entry.key,
          'value': entry.value,
        });
      }
      return PointsReportModel(
        totalPoints: (json['total_points_awarded'] as num?)?.toInt() ?? 0,
        totalValue: (json['total_discount_value'] as num?)?.toDouble() ?? 0.0,
        customerCount: (json['total_points_redeemed'] as num?)?.toInt() ?? 0,
        transactionCount: (json['total_points_expired'] as num?)?.toInt() ?? 0,
        rows: rows,
      );
    }

    final isPaginated = json.containsKey('current_page');

    final rowsList = isPaginated
        ? (json['data'] as List<dynamic>?)
        : (json['data'] as List<dynamic>?);

    final rows = rowsList
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        const [];

    return PointsReportModel(
      totalPoints: json['total_points'] as int? ?? 0,
      totalValue: (json['total_value'] as num?)?.toDouble() ?? 0.0,
      customerCount: json['customer_count'] as int? ??
          json['total_customers'] as int? ??
          0,
      transactionCount: json['transaction_count'] as int? ??
          json['total_transactions'] as int? ??
          (isPaginated ? (json['total'] as int? ?? 0) : 0),
      rows: rows,
    );
  }
}
