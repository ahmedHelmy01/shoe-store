
class AdminSalesPoint {
  final DateTime day;
  final double revenue;
  final int orders;

  const AdminSalesPoint({
    required this.day,
    required this.revenue,
    required this.orders,
  });
}

class AdminCategoryShare {
  final String name;
  final double value;

  const AdminCategoryShare({required this.name, required this.value});
}

class AdminStatusShare {
  final String status;
  final double value;

  const AdminStatusShare({required this.status, required this.value});
}
