import 'package:flutter/material.dart';

class AppRouteNames {
  static const String splash = '/splash';
  static const String webstoreLogin = '/webstore/login';
  static const String webstoreRegister = '/webstore/register';
  static const String webstoreForgotPassword = '/webstore/forgot-password';
  static const String webstoreOtp = '/webstore/otp';
  static const String webstoreResetPassword = '/webstore/reset-password';
  static const String webstoreMain = '/webstore/main';
  static const String webstoreCheckout = '/webstore/checkout';
  static const String webstoreOrderTrack = '/webstore/order-track';
  static const String webstoreRateOrder = '/webstore/rate-order';
  static const String webstoreOrderList = '/webstore/order-list';
  static const String webstoreWishlist = '/webstore/wishlist';
  static const String webstorePoints = '/webstore/points';
  static const String webstoreOrderDetails = '/webstore/order-details';

  // ─── WebStore Admin ───────────────────────────────
  static const String webstoreAdmin = '/webstore/admin';
  static const String webstoreAdminDashboard = '/webstore/admin/dashboard';
  static const String webstoreAdminUsers = '/webstore/admin/users';
  static const String webstoreAdminProducts = '/webstore/admin/products';
  static const String webstoreAdminCategories = '/webstore/admin/categories';
  static const String webstoreAdminCompanies = '/webstore/admin/companies';
  static const String webstoreAdminFilters = '/webstore/admin/filters';
  static const String webstoreAdminOrders = '/webstore/admin/orders';
  static const String webstoreAdminOrderCreate = '/webstore/admin/orders/new';
  static const String webstoreAdminCoupons = '/webstore/admin/coupons';
  static const String webstoreAdminBranches = '/webstore/admin/branches';
  static const String webstoreAdminWarehouses = '/webstore/admin/warehouses';
  static const String webstoreAdminSliders = '/webstore/admin/sliders';
  static const String webstoreAdminAds = '/webstore/admin/ads';
  static const String webstoreAdminBoardings = '/webstore/admin/boardings';
  static const String webstoreAdminPages = '/webstore/admin/pages';
  static const String webstoreAdminProperties = '/webstore/admin/properties';
  static const String webstoreAdminPaymentStatuses = '/webstore/admin/payment-statuses';
  static const String webstoreAdminPaymentMethods = '/webstore/admin/payment-methods';
  static const String webstoreAdminCities = '/webstore/admin/cities';
  static const String webstoreAdminGovernorates = '/webstore/admin/governorates';
  static const String webstoreAdminSettings = '/webstore/admin/settings';
}

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<T?> push<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  static Future<T?> replace<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(
      context,
    ).pushReplacementNamed(routeName, arguments: arguments);
  }

  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }

  static void popToRoot(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  static Future<bool> maybePop<T>(BuildContext context, [T? result]) {
    return Navigator.of(context).maybePop(result);
  }

  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }
}
