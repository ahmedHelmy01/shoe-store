import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';

// Models for type casting in arguments

class RouteGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(title: Text(LocaleKeys.common.error.tr(context: context))),
          body: Center(child: Text(LocaleKeys.common.page_not_found.tr(context: context))),
        );
      },
    );
  }
}
