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
