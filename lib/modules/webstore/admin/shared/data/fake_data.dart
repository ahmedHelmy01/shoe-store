import 'dart:math';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/category_model.dart';
import 'package:erp/modules/webstore/auth/data/models/webstore_user_model.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';
import 'package:erp/modules/webstore/admin/features/dashboard/data/models/dashboard_models.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/data/models/company_row.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/data/models/filter_row.dart';

/// Temporary seeded fake data for admin UI until APIs are wired.
class FakeData {
  static List<WebStoreProduct> products({int count = 57, int seed = 7}) {
    final rnd = Random(seed);
    final names = [
      'Panadol Extra',
      'Vitamin C 1000',
      'La Roche Cream',
      'Blood Pressure Monitor',
      'Sunscreen SPF 50',
      'Baby Shampoo',
      'Insulin Syringe',
      'Face Wash',
      'Omega 3',
      'Antibiotic 1g',
    ];

    return List.generate(count, (i) {
      final price = (rnd.nextInt(9000) + 500) / 100;
      final stock = rnd.nextInt(120);
      final old = rnd.nextBool() ? (price + (rnd.nextInt(2500) / 100)) : null;
      return WebStoreProduct(
        id: i + 1,
        name: '${names[rnd.nextInt(names.length)]} #${i + 1}',
        price: price,
        oldPrice: old,
        stock: stock,
        image: null,
        brand: rnd.nextBool() ? 'Brand ${String.fromCharCode(65 + rnd.nextInt(6))}' : null,
        rating: (rnd.nextInt(50) + 50) / 20.0, // 2.5 - 5.0
        reviewsCount: rnd.nextInt(1200),
        isFeatured: rnd.nextInt(10) == 0,
        isNew: rnd.nextInt(8) == 0,
        attributes: const {},
      );
    });
  }

  static List<WebStoreCategory> categories({int count = 24, int seed = 11}) {
    final rnd = Random(seed);
    const names = [
      'Skin Care',
      'Supplements',
      'Medical Devices',
      'Baby Care',
      'Hair Care',
      'Oral Care',
      'Personal Care',
      'Vitamins',
    ];

    return List.generate(count, (i) {
      final id = i + 1;
      final hasParent = i > 7 && rnd.nextBool();
      final parentId = hasParent ? rnd.nextInt(min(8, id - 1)) + 1 : null;
      return WebStoreCategory(
        id: id,
        name: '${names[rnd.nextInt(names.length)]} ${id <= 8 ? '' : '#$id'}'.trim(),
        description: rnd.nextBool() ? 'Category description $id' : null,
        parentId: parentId,
        productsCount: rnd.nextInt(420),
        isActive: rnd.nextInt(10) != 0,
      );
    });
  }

  static List<WebStoreUser> users({int count = 55, int seed = 19}) {
    final rnd = Random(seed);
    const first = ['Ahmed', 'Mohamed', 'Omar', 'Youssef', 'Sara', 'Mona', 'Nour', 'Hala', 'Kareem', 'Hassan'];
    const last = ['Ali', 'Ibrahim', 'Mostafa', 'Hussein', 'Sayed', 'Mahmoud', 'Fathy', 'Gamal'];

    return List.generate(count, (i) {
      final id = i + 1;
      final name = '${first[rnd.nextInt(first.length)]} ${last[rnd.nextInt(last.length)]}';
      final email = rnd.nextBool() ? 'user$id@mail.com' : null;
      final mobile = rnd.nextBool() ? '+20 10${rnd.nextInt(90000000) + 10000000}' : null;
      return WebStoreUser(id: id, name: name, email: email, mobile: mobile);
    });
  }

  static List<OrderRow> orders({int count = 63, int seed = 23}) {
    final rnd = Random(seed);
    const statuses = ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];
    const payments = ['Cash', 'Card', 'InstaPay'];

    return List.generate(count, (i) {
      final id = 1000 + i + 1;
      final total = (rnd.nextInt(250000) + 1500) / 100; // 15 - 2500
      final items = rnd.nextInt(6) + 1;
      final createdAt = DateTime.now().subtract(Duration(days: rnd.nextInt(70), hours: rnd.nextInt(24)));
      return OrderRow(
        id: id,
        customer: 'Customer ${rnd.nextInt(200) + 1}',
        status: statuses[rnd.nextInt(statuses.length)],
        payment: payments[rnd.nextInt(payments.length)],
        total: total,
        itemsCount: items,
        createdAt: createdAt,
      );
    });
  }

  static List<AdminKpi> dashboardKpis({int seed = 31}) {
    final rnd = Random(seed);
    int delta() => (rnd.nextInt(22) + 2) * (rnd.nextBool() ? 1 : -1);
    bool pos(int d) => d >= 0;

    final d1 = delta();
    final d2 = delta();
    final d3 = delta();
    final d4 = delta();

    return [
      AdminKpi(title: 'Orders (Today)', value: '${rnd.nextInt(140) + 20}', deltaPercent: d1.abs(), positive: pos(d1)),
      AdminKpi(title: 'Revenue (7d)', value: '${(rnd.nextInt(900000) + 120000) / 100} EGP', deltaPercent: d2.abs(), positive: pos(d2)),
      AdminKpi(title: 'Active Users', value: '${rnd.nextInt(1800) + 300}', deltaPercent: d3.abs(), positive: pos(d3)),
      AdminKpi(title: 'Low Stock', value: '${rnd.nextInt(28) + 4}', deltaPercent: d4.abs(), positive: !pos(d4)),
    ];
  }

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

  static List<CompanyRow> companies({int count = 26, int seed = 53}) {
    final rnd = Random(seed);
    const names = [
      'Astra Pharma',
      'Nile Med',
      'Cairo Labs',
      'Delta Care',
      'Sinai Health',
      'Orion Pharma',
      'Nova Medical',
      'Prime Remedies',
    ];
    const countries = ['EG', 'DE', 'US', 'UK', 'TR', 'IN', 'FR'];

    return List.generate(count, (i) {
      final id = i + 1;
      return CompanyRow(
        id: id,
        name: '${names[rnd.nextInt(names.length)]} ${id <= 8 ? '' : '#$id'}'.trim(),
        code: 'CMP-${1000 + id}',
        country: countries[rnd.nextInt(countries.length)],
        productsCount: rnd.nextInt(480),
        isActive: rnd.nextInt(10) != 0,
      );
    });
  }

  static List<FilterRow> filters({int count = 18, int seed = 59}) {
    final rnd = Random(seed);
    const names = [
      'Brand',
      'Price Range',
      'Rating',
      'Availability',
      'Category',
      'Form',
      'Age',
      'Skin Type',
      'Size',
      'Color',
    ];
    const types = ['checkbox', 'range', 'select', 'toggle'];

    return List.generate(count, (i) {
      final id = i + 1;
      final type = types[rnd.nextInt(types.length)];
      final options = type == 'range' ? 0 : (rnd.nextInt(18) + 2);
      return FilterRow(
        id: id,
        name: '${names[rnd.nextInt(names.length)]}${rnd.nextBool() ? '' : ' #$id'}'.trim(),
        type: type,
        optionsCount: options,
        isActive: rnd.nextInt(10) != 0,
      );
    });
  }
}




