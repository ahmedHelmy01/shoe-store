import 'admin_dashboard_models.dart';

class AdminStatisticsModel {
  final int totalOrders;
  final double totalRevenue;
  final int totalCustomers;
  final int todayOrders;
  final double todayRevenue;
  final List<TopProductModel> topProducts;
  final List<AdminSalesPoint> inventoryMovement;

  AdminStatisticsModel({
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalCustomers,
    required this.todayOrders,
    required this.todayRevenue,
    required this.topProducts,
    required this.inventoryMovement,
  });

  factory AdminStatisticsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    final rawTopProducts = (data['top_products'] as List? ?? []);
    final rawInventoryMovement = (data['inventory_movement'] as List? ?? []);

    return AdminStatisticsModel(
      totalOrders: _parseInt(data['total_orders']),
      totalRevenue: _parseDouble(data['total_revenue']),
      totalCustomers: _parseInt(data['total_customers']),
      todayOrders: _parseInt(data['today_orders']),
      todayRevenue: _parseDouble(data['today_revenue']),
      topProducts: rawTopProducts
          .map((e) => TopProductModel.fromJson(e))
          .toList(),
      inventoryMovement: rawInventoryMovement
          .map((e) => AdminSalesPoint(
                day: DateTime.tryParse(e['date']?.toString() ?? '') ?? DateTime.now(),
                revenue: _parseDouble(e['revenue']),
                orders: _parseInt(e['orders']),
              ))
          .toList(),
    );
  }

  /// Safely parse a value that could be int, double, or String to int.
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  /// Safely parse a value that could be int, double, or String to double.
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  factory AdminStatisticsModel.demo() {
    return AdminStatisticsModel(
      totalOrders: 1250,
      totalRevenue: 450000.0,
      totalCustomers: 850,
      todayOrders: 12,
      todayRevenue: 2450.0,
      topProducts: [
        TopProductModel(productId: 1, productName: 'Skin Care Bundle', totalQty: 45, totalRevenue: 12500),
        TopProductModel(productId: 2, productName: 'Organic Vitamin C', totalQty: 32, totalRevenue: 8400),
        TopProductModel(productId: 3, productName: 'Hydrating Serum', totalQty: 28, totalRevenue: 7200),
        TopProductModel(productId: 4, productName: 'Sunscreen SPF 50', totalQty: 25, totalRevenue: 5100),
        TopProductModel(productId: 5, productName: 'Night Repair Cream', totalQty: 18, totalRevenue: 4800),
      ],
      inventoryMovement: [
        AdminSalesPoint(day: DateTime.now().subtract(const Duration(days: 150)), revenue: 0, orders: 150),
        AdminSalesPoint(day: DateTime.now().subtract(const Duration(days: 120)), revenue: 0, orders: 280),
        AdminSalesPoint(day: DateTime.now().subtract(const Duration(days: 90)), revenue: 0, orders: 190),
        AdminSalesPoint(day: DateTime.now().subtract(const Duration(days: 60)), revenue: 0, orders: 340),
        AdminSalesPoint(day: DateTime.now().subtract(const Duration(days: 30)), revenue: 0, orders: 420),
        AdminSalesPoint(day: DateTime.now(), revenue: 0, orders: 380),
      ],
    );
  }
}

class TopProductModel {
  final int productId;
  final String productName;
  final int totalQty;
  final double totalRevenue;

  TopProductModel({
    required this.productId,
    required this.productName,
    required this.totalQty,
    required this.totalRevenue,
  });

  factory TopProductModel.fromJson(Map<String, dynamic> json) {
    return TopProductModel(
      productId: AdminStatisticsModel._parseInt(json['product_id']),
      productName: json['product_name']?.toString() ?? 'Unknown',
      totalQty: AdminStatisticsModel._parseInt(json['total_qty']),
      totalRevenue: AdminStatisticsModel._parseDouble(json['total_revenue']),
    );
  }
}
