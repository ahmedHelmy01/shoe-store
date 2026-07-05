class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

class TopSpenderRow {
  final String name;
  final int orders;
  final double spent;
  final bool isActive;
  final String lastOrder;

  TopSpenderRow(
    this.name,
    this.orders,
    this.spent,
    this.isActive,
    this.lastOrder,
  );
}

class ClientReport {
  final int? totalOrders;
  final double? totalSpent;
  final int? periodOrders;
  final double? periodSpent;
  final String? customerName;
  final String? customerMobile;

  const ClientReport({
    this.totalOrders,
    this.totalSpent,
    this.periodOrders,
    this.periodSpent,
    this.customerName,
    this.customerMobile,
  });

  factory ClientReport.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return ClientReport(
      totalOrders: data['total_orders'] as int?,
      totalSpent: (data['total_spent'] as num?)?.toDouble(),
      periodOrders: data['period_orders'] as int?,
      periodSpent: (data['period_spent'] as num?)?.toDouble(),
      customerName: data['customer_name'] as String?,
      customerMobile: data['customer_mobile'] as String?,
    );
  }
}