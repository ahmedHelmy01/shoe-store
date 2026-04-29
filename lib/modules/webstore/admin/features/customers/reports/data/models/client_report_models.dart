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
