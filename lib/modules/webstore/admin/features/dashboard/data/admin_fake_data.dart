import 'dart:math';
import 'models/admin_dashboard_models.dart';

/// Temporary seeded fake data for admin Dashboard.
class AdminDashboardFakeData {

  static List<AdminSalesPoint> dashboardSales({int days = 14, int seed = 37}) {
    final rnd = Random(seed);
    final now = DateTime.now();

    return List.generate(days, (i) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: (days - 1) - i));
      final base = 1200 + (i * 140);
      final noise = rnd.nextInt(900) - 400;
      final revenue = max(300, base + noise).toDouble();
      final orders = max(3, (revenue / (rnd.nextInt(90) + 70)).round());
      return AdminSalesPoint(day: day, revenue: revenue, orders: orders);
    });
  }

  static List<AdminCategoryShare> dashboardTopCategories({int seed = 41}) {
    final rnd = Random(seed);
    const names = [
      'Skin Care',
      'Supplements',
      'Baby Care',
      'Oral Care',
      'Medical Devices',
    ];
    return List.generate(names.length, (i) {
      return AdminCategoryShare(name: names[i], value: (rnd.nextInt(90) + 20).toDouble());
    });
  }

  static List<AdminStatusShare> dashboardOrderStatus({int seed = 43}) {
    final rnd = Random(seed);
    const names = ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];
    final raw = names.map((_) => rnd.nextInt(60) + 10).toList();
    final total = raw.fold<int>(0, (a, b) => a + b);
    return List.generate(names.length, (i) {
      return AdminStatusShare(status: names[i], value: (raw[i] / total) * 100.0);
    });
  }
}
