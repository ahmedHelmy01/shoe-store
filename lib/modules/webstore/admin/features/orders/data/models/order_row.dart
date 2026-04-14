class OrderRow {
  final int id;
  final String customer;
  final String status;
  final String payment;
  final double total;
  final int itemsCount;
  final DateTime createdAt;

  const OrderRow({
    required this.id,
    required this.customer,
    required this.status,
    required this.payment,
    required this.total,
    required this.itemsCount,
    required this.createdAt,
  });

  String get customerName => customer;
  double get totalPrice => total;

  factory OrderRow.fromJson(Map<String, dynamic> json) {
    return OrderRow(
      id: json['id'] as int? ?? 0,
      customer: json['customer'] ?? json['customer_name'] ?? 'Unknown',
      status: json['status'] as String? ?? 'pending',
      payment: json['payment'] as String? ?? 'cod',
      total: (json['total'] ?? json['total_price'] as num? ?? 0).toDouble(),
      itemsCount: json['items_count'] as int? ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }

  OrderRow copyWith({
    int? id,
    String? customer,
    String? status,
    String? payment,
    double? total,
    int? itemsCount,
    DateTime? createdAt,
  }) {
    return OrderRow(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      status: status ?? this.status,
      payment: payment ?? this.payment,
      total: total ?? this.total,
      itemsCount: itemsCount ?? this.itemsCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}


