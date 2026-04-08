import 'package:flutter/material.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/modules/webstore/admin/presentation/admin_shell.dart';
import 'package:erp/modules/webstore/admin/presentation/admin_routes.dart';

class AdminRouteGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.webstoreAdmin:
      case AppRouteNames.webstoreAdminDashboard:
      case AppRouteNames.webstoreAdminUsers:
      case AppRouteNames.webstoreAdminProducts:
      case AppRouteNames.webstoreAdminCategories:
      case AppRouteNames.webstoreAdminCompanies:
      case AppRouteNames.webstoreAdminFilters:
      case AppRouteNames.webstoreAdminOrders:
      case AppRouteNames.webstoreAdminOrderCreate:
      case AppRouteNames.webstoreAdminSettings:
      case '/':
      case null:
        final id = AdminRoutes.fromRouteName(settings.name);
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AdminShell(initial: id),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AdminShell(),
        );
    }
  }
}

