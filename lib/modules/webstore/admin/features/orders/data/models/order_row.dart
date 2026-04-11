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


