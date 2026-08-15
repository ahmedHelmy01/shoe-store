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
  static const String webstorePage = '/webstore/page';
  static const String webstoreCatalogProducts = '/webstore/catalog/products';
  static const String webstoreCategoryDrillDown = '/webstore/categories/drill';
  static const String webstoreAddresses = '/webstore/addresses';
  static const String webstoreAddEditAddress = '/webstore/addresses/add-edit';
  static const String webstoreNotifications = '/webstore/notifications';
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

  /// Context-less push using the global navigator key
  static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> replace<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    // Check if the context is still mounted before using it
    if (context.mounted) {
      return Navigator.of(context).pushReplacementNamed(
        routeName,
        arguments: arguments,
      );
    }
    // Fallback to context-less navigation
    return replaceNamed(routeName, arguments: arguments);
  }

  /// Context-less replace using the global navigator key
  static Future<T?> replaceNamed<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed<T, dynamic>(
      routeName,
      arguments: arguments,
    );
  }

  static void pop<T>(BuildContext context, [T? result]) {
    if (context.mounted) {
      Navigator.of(context).pop(result);
    } else {
      navigatorKey.currentState!.pop(result);
    }
  }

  static void popToRoot(BuildContext context) {
    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  static Future<bool> maybePop<T>(BuildContext context, [T? result]) {
    return Navigator.of(context).maybePop(result);
  }

  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    if (context.mounted) {
      return Navigator.of(context).pushNamedAndRemoveUntil(
        routeName,
        (route) => false,
        arguments: arguments,
      );
    }
    return pushNamedAndRemoveUntilNoContext(routeName, arguments: arguments);
  }

  /// Context-less pushAndRemoveUntil
  static Future<T?> pushNamedAndRemoveUntilNoContext<T>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }
}
