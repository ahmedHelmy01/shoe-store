import 'package:flutter/material.dart';
import 'package:erp/core/router/app_navigator.dart';

enum AdminRouteId {
  dashboard,
  catalog,
  customerGroup,
  users,
  customerGroups,
  products,
  categories,
  companies,
  filters,
  orderGroup,
  orders,
  orderCreate,
  orderStatuses,
  coupons,
  paymentStatuses,
  paymentMethods,
  operations,
  branches,
  warehouses,
  cities,
  governorates,
  storefront,
  sliders,
  ads,
  boardings,
  pages,
  properties,
  supportGroup,
  contacts,
  settings,
  clientReports,
  countries,
  login,
  addresses,
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
          title: 'Tags',
          icon: Icons.tune_rounded,
        ),
      ],
    ),
    AdminNavNode(
      id: AdminRouteId.operations,
      title: 'Operations',
      icon: Icons.settings_accessibility_rounded,
      children: [
        AdminNavNode(
          id: AdminRouteId.branches,
          routeName: AppRouteNames.webstoreAdminBranches,
          title: 'Branches',
          icon: Icons.store_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.warehouses,
          routeName: AppRouteNames.webstoreAdminWarehouses,
          title: 'Warehouses',
          icon: Icons.warehouse_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.governorates,
          routeName: AppRouteNames.webstoreAdminGovernorates,
          title: 'Governorates',
          icon: Icons.map_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.cities,
          routeName: AppRouteNames.webstoreAdminCities,
          title: 'Cities',
          icon: Icons.location_city_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.countries,
          routeName: AppRouteNames.webstoreAdminCountries,
          title: 'Countries',
          icon: Icons.public_rounded,
        ),
      ],
    ),
    AdminNavNode(
      id: AdminRouteId.orderGroup,
      title: 'Sales & Marketing',
      icon: Icons.receipt_long_rounded,
      children: [
        AdminNavNode(
          id: AdminRouteId.orders,
          routeName: AppRouteNames.webstoreAdminOrders,
          title: 'All orders',
          icon: Icons.list_alt_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.orderStatuses,
          routeName: AppRouteNames.webstoreAdminOrderStatuses,
          title: 'Order Statuses',
          icon: Icons.flag_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.coupons,
          routeName: AppRouteNames.webstoreAdminCoupons,
          title: 'Coupons',
          icon: Icons.local_offer_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.paymentMethods,
          routeName: AppRouteNames.webstoreAdminPaymentMethods,
          title: 'Payment Methods',
          icon: Icons.payment_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.paymentStatuses,
          routeName: AppRouteNames.webstoreAdminPaymentStatuses,
          title: 'Payment Statuses',
          icon: Icons.info_outline_rounded,
        ),
      ],
    ),
    AdminNavNode(
      id: AdminRouteId.storefront,
      title: 'Storefront',
      icon: Icons.web_rounded,
      children: [
        AdminNavNode(
          id: AdminRouteId.sliders,
          routeName: AppRouteNames.webstoreAdminSliders,
          title: 'Sliders',
          icon: Icons.view_carousel_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.ads,
          routeName: AppRouteNames.webstoreAdminAds,
          title: 'Ads',
          icon: Icons.campaign_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.boardings,
          routeName: AppRouteNames.webstoreAdminBoardings,
          title: 'Boardings',
          icon: Icons.phonelink_setup_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.pages,
          routeName: AppRouteNames.webstoreAdminPages,
          title: 'Pages',
          icon: Icons.description_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.properties,
          routeName: AppRouteNames.webstoreAdminProperties,
          title: 'Properties',
          icon: Icons.settings_input_component_rounded,
        ),
      ],
    ),
    AdminNavNode(
      id: AdminRouteId.customerGroup,
      title: 'Customers',
      icon: Icons.people_alt_rounded,
      children: [
        AdminNavNode(
          id: AdminRouteId.users,
          routeName: AppRouteNames.webstoreAdminUsers,
          title: 'Users',
          icon: Icons.person_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.customerGroups,
          routeName: AppRouteNames.webstoreAdminCustomerGroups,
          title: 'Customer Groups',
          icon: Icons.groups_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.clientReports,
          routeName: AppRouteNames.webstoreAdminClientReports,
          title: 'Clients Reports',
          icon: Icons.analytics_rounded,
        ),
        AdminNavNode(
          id: AdminRouteId.addresses,
          routeName: AppRouteNames.webstoreAdminAddresses,
          title: 'Addresses',
          icon: Icons.location_on_rounded,
        ),
      ],
    ),
    AdminNavNode(
      id: AdminRouteId.supportGroup,
      title: 'Support',
      icon: Icons.support_agent_rounded,
      children: [
        AdminNavNode(
          id: AdminRouteId.contacts,
          routeName: AppRouteNames.webstoreAdminContacts,
          title: 'Messages',
          icon: Icons.chat_bubble_outline_rounded,
        ),
      ],
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
      AppRouteNames.webstoreAdminCustomerGroups => AdminRouteId.customerGroups,
      AppRouteNames.webstoreAdminProducts => AdminRouteId.products,
      AppRouteNames.webstoreAdminCategories => AdminRouteId.categories,
      AppRouteNames.webstoreAdminCompanies => AdminRouteId.companies,
      AppRouteNames.webstoreAdminFilters => AdminRouteId.filters,
      AppRouteNames.webstoreAdminOrders => AdminRouteId.orders,
      AppRouteNames.webstoreAdminOrderCreate => AdminRouteId.orderCreate,
      AppRouteNames.webstoreAdminOrderStatuses => AdminRouteId.orderStatuses,
      AppRouteNames.webstoreAdminCoupons => AdminRouteId.coupons,
      AppRouteNames.webstoreAdminBranches => AdminRouteId.branches,
      AppRouteNames.webstoreAdminWarehouses => AdminRouteId.warehouses,
      AppRouteNames.webstoreAdminSliders => AdminRouteId.sliders,
      AppRouteNames.webstoreAdminAds => AdminRouteId.ads,
      AppRouteNames.webstoreAdminBoardings => AdminRouteId.boardings,
      AppRouteNames.webstoreAdminPages => AdminRouteId.pages,
      AppRouteNames.webstoreAdminProperties => AdminRouteId.properties,
      AppRouteNames.webstoreAdminPaymentStatuses => AdminRouteId.paymentStatuses,
      AppRouteNames.webstoreAdminPaymentMethods => AdminRouteId.paymentMethods,
      AppRouteNames.webstoreAdminCities => AdminRouteId.cities,
      AppRouteNames.webstoreAdminGovernorates => AdminRouteId.governorates,
      AppRouteNames.webstoreAdminSettings => AdminRouteId.settings,
      AppRouteNames.webstoreAdminClientReports => AdminRouteId.clientReports,
      AppRouteNames.webstoreAdminContacts => AdminRouteId.contacts,
      AppRouteNames.webstoreAdminCountries => AdminRouteId.countries,
      AppRouteNames.webstoreAdminAddresses => AdminRouteId.addresses,
      'login' => AdminRouteId.login,
      _ => AdminRouteId.dashboard,
    };
  }

  static String toRouteName(AdminRouteId id) {
    return switch (id) {
      AdminRouteId.login => 'login',
      AdminRouteId.dashboard => AppRouteNames.webstoreAdminDashboard,
      AdminRouteId.users => AppRouteNames.webstoreAdminUsers,
      AdminRouteId.customerGroups => AppRouteNames.webstoreAdminCustomerGroups,
      AdminRouteId.products => AppRouteNames.webstoreAdminProducts,
      AdminRouteId.categories => AppRouteNames.webstoreAdminCategories,
      AdminRouteId.companies => AppRouteNames.webstoreAdminCompanies,
      AdminRouteId.filters => AppRouteNames.webstoreAdminFilters,
      AdminRouteId.orderGroup => AppRouteNames.webstoreAdminOrders,
      AdminRouteId.orders => AppRouteNames.webstoreAdminOrders,
      AdminRouteId.orderCreate => AppRouteNames.webstoreAdminOrderCreate,
      AdminRouteId.orderStatuses => AppRouteNames.webstoreAdminOrderStatuses,
      AdminRouteId.coupons => AppRouteNames.webstoreAdminCoupons,
      AdminRouteId.branches => AppRouteNames.webstoreAdminBranches,
      AdminRouteId.warehouses => AppRouteNames.webstoreAdminWarehouses,
      AdminRouteId.sliders => AppRouteNames.webstoreAdminSliders,
      AdminRouteId.ads => AppRouteNames.webstoreAdminAds,
      AdminRouteId.boardings => AppRouteNames.webstoreAdminBoardings,
      AdminRouteId.pages => AppRouteNames.webstoreAdminPages,
      AdminRouteId.properties => AppRouteNames.webstoreAdminProperties,
      AdminRouteId.paymentStatuses => AppRouteNames.webstoreAdminPaymentStatuses,
      AdminRouteId.paymentMethods => AppRouteNames.webstoreAdminPaymentMethods,
      AdminRouteId.cities => AppRouteNames.webstoreAdminCities,
      AdminRouteId.governorates => AppRouteNames.webstoreAdminGovernorates,
      AdminRouteId.settings => AppRouteNames.webstoreAdminSettings,
      AdminRouteId.clientReports => AppRouteNames.webstoreAdminClientReports,
      AdminRouteId.contacts => AppRouteNames.webstoreAdminContacts,
      AdminRouteId.countries => AppRouteNames.webstoreAdminCountries,
      AdminRouteId.addresses => AppRouteNames.webstoreAdminAddresses,
      AdminRouteId.catalog => AppRouteNames.webstoreAdminProducts,
      AdminRouteId.operations => AdminRouteId.governorates.toString(),
      AdminRouteId.storefront => AdminRouteId.sliders.toString(),
      AdminRouteId.customerGroup => AppRouteNames.webstoreAdminUsers,
      AdminRouteId.supportGroup => AppRouteNames.webstoreAdminContacts,
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
