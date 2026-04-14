class OrderCartLine {
  final int productId;
  final String name;
  final double unitPrice;
  final int qty;

  const OrderCartLine({
    required this.productId,
    required this.name,
    required this.unitPrice,
    this.qty = 1,
  });

  double get lineTotal => unitPrice * qty;

  OrderCartLine copyWith({
    int? productId,
    String? name,
    double? unitPrice,
    int? qty,
  }) {
    return OrderCartLine(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      qty: qty ?? this.qty,
    );
  }
}
