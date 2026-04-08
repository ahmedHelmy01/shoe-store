class OrderCartLine {
  final int productId;
  final String name;
  final double unitPrice;
  int qty;

  OrderCartLine({
    required this.productId,
    required this.name,
    required this.unitPrice,
  }) : qty = 1;

  double get lineTotal => unitPrice * qty;
}
