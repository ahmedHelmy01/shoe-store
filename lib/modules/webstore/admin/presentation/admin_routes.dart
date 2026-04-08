import 'package:flutter/material.dart';
import 'package:erp/core/router/app_navigator.dart';

enum AdminRouteId {
  dashboard,
  catalog,
  users,
  products,
  categories,
  companies,
  filters,
  orderGroup,
  orders,
  orderCreate,
  settings,
}

class AdminNavNode {
  final AdminRouteId id;
  final String title;
  final IconData icon;
  final String? routeName;
  final List<AdminNavNode> children;

  const AdminNavNode({
    required this.id,
    required this.title,
    required this.icon,
    this.routeName,
    this.children = const [],
  });

  bool get isGroup => children.isNotEmpty;
}

class AdminRoutes {
  static const all = <AdminNavNode>[
    AdminNavNode(
      id: AdminRouteId.dashboard,
      routeName: AppRouteNames.webstoreAdminDashboard,
      title: 'Dashboard',
      icon: Icons.dashboard_rounded,
    ),
    AdminNavNode(
      id: AdminRouteId.catalog,
      title: 'Catalog',
      icon: Icons.category_rounded,
      children: [
        AdminNavNode(
          id: AdminRouteId.products,
          routeName: AppRouteNames.webstoreAdminProducts,
          title: 'Products',
          icon: Icons.inventory_2_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.categories,
          routeName: AppRouteNames.webstoreAdminCategories,
          title: 'Categories',
          icon: Icons.account_tree_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.companies,
          routeName: AppRouteNames.webstoreAdminCompanies,
          title: 'Companies',
          icon: Icons.apartment_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.filters,
          routeName: AppRouteNames.webstoreAdminFilters,
          title: 'Filters',
          icon: Icons.tune_rounded,
        ),
      ],
    ),
    AdminNavNode(
      id: AdminRouteId.orderGroup,
      title: 'Orders',
      icon: Icons.receipt_long_rounded,
      children: [
        AdminNavNode(
          id: AdminRouteId.orders,
          routeName: AppRouteNames.webstoreAdminOrders,
          title: 'All orders',
          icon: Icons.list_alt_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.orderCreate,
          routeName: AppRouteNames.webstoreAdminOrderCreate,
          title: 'New order',
          icon: Icons.add_shopping_cart_rounded,
        ),
      ],
    ),
    AdminNavNode(
      id: AdminRouteId.users,
      routeName: AppRouteNames.webstoreAdminUsers,
      title: 'Users',
      icon: Icons.people_alt_rounded,
    ),
    AdminNavNode(
      id: AdminRouteId.settings,
      routeName: AppRouteNames.webstoreAdminSettings,
      title: 'Settings',
      icon: Icons.settings_rounded,
    ),
  ];

  static AdminRouteId fromRouteName(String? name) {
    return switch (name) {
      AppRouteNames.webstoreAdminDashboard => AdminRouteId.dashboard,
      AppRouteNames.webstoreAdmin => AdminRouteId.dashboard,
      AppRouteNames.webstoreAdminUsers => AdminRouteId.users,
      AppRouteNames.webstoreAdminProducts => AdminRouteId.products,
      AppRouteNames.webstoreAdminCategories => AdminRouteId.categories,
      AppRouteNames.webstoreAdminCompanies => AdminRouteId.companies,
      AppRouteNames.webstoreAdminFilters => AdminRouteId.filters,
      AppRouteNames.webstoreAdminOrders => AdminRouteId.orders,
      AppRouteNames.webstoreAdminOrderCreate => AdminRouteId.orderCreate,
      AppRouteNames.webstoreAdminSettings => AdminRouteId.settings,
      _ => AdminRouteId.dashboard,
    };
  }

  static String toRouteName(AdminRouteId id) {
    return switch (id) {
      AdminRouteId.dashboard => AppRouteNames.webstoreAdminDashboard,
      AdminRouteId.users => AppRouteNames.webstoreAdminUsers,
      AdminRouteId.products => AppRouteNames.webstoreAdminProducts,
      AdminRouteId.categories => AppRouteNames.webstoreAdminCategories,
      AdminRouteId.companies => AppRouteNames.webstoreAdminCompanies,
      AdminRouteId.filters => AppRouteNames.webstoreAdminFilters,
      AdminRouteId.orderGroup => AppRouteNames.webstoreAdminOrders,
      AdminRouteId.orders => AppRouteNames.webstoreAdminOrders,
      AdminRouteId.orderCreate => AppRouteNames.webstoreAdminOrderCreate,
      AdminRouteId.settings => AppRouteNames.webstoreAdminSettings,
      AdminRouteId.catalog => AppRouteNames.webstoreAdminProducts,
    };
  }

  static AdminNavNode? findNode(AdminRouteId id) {
    for (final n in all) {
      final hit = _findNodeIn(n, id);
      if (hit != null) return hit;
    }
    return null;
  }

  static String titleOf(AdminRouteId id) {
    return findNode(id)?.title ?? 'Admin';
  }

  static AdminNavNode? _findNodeIn(AdminNavNode node, AdminRouteId id) {
    if (node.id == id) return node;
    for (final c in node.children) {
      final hit = _findNodeIn(c, id);
      if (hit != null) return hit;
    }
    return null;
  }
}

