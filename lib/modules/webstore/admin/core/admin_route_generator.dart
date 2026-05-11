import 'package:flutter/material.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/modules/webstore/admin/core/admin_shell.dart';
import 'package:erp/modules/webstore/admin/core/admin_routes.dart';

class AdminRouteGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        if (settings.name != null && settings.name!.startsWith(AppRouteNames.webstoreAdmin)) {
          final id = AdminRoutes.fromRouteName(settings.name);
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => AdminShell(initial: id),
          );
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AdminShell(),
        );
    }
  }
}
