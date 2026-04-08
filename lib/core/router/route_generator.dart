import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/modules/webstore/auth/presentation/view/webstore_login_screen.dart';
import 'package:erp/modules/webstore/auth/presentation/view/webstore_register_screen.dart';
import 'package:erp/modules/webstore/auth/presentation/view/webstore_forgot_password_screen.dart';
import 'package:erp/modules/webstore/auth/presentation/view/webstore_otp_screen.dart';
import 'package:erp/modules/webstore/auth/presentation/view/webstore_reset_password_screen.dart';
import 'package:erp/core/common_widget/main_layout/webstore_main_layout.dart';
import 'package:erp/modules/webstore/checkout/presentation/view/webstore_checkout_view.dart';
import 'package:erp/modules/webstore/orders/presentation/view/webstore_order_track_view.dart';
import 'package:erp/modules/webstore/orders/presentation/view/webstore_rate_order_view.dart';
import 'package:erp/modules/webstore/orders/presentation/view/webstore_order_list_view.dart';
import 'package:erp/modules/webstore/orders/presentation/view/webstore_order_details_view.dart';
import 'package:erp/modules/webstore/wishlist/presentation/view/webstore_wishlist_view.dart';
import 'package:erp/modules/webstore/profile/presentation/view/webstore_points_view.dart';

// Models for type casting in arguments

class RouteGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.webstoreLogin:
        return MaterialPageRoute(builder: (_) => const WebStoreLoginScreen());
      case AppRouteNames.webstoreRegister:
        return MaterialPageRoute(builder: (_) => const WebStoreRegisterScreen());
      case AppRouteNames.webstoreForgotPassword:
        return MaterialPageRoute(builder: (_) => const WebStoreForgotPasswordScreen());
      case AppRouteNames.webstoreOtp:
        return MaterialPageRoute(builder: (_) => const WebStoreOtpScreen());
      case AppRouteNames.webstoreResetPassword:
        return MaterialPageRoute(builder: (_) => const WebStoreResetPasswordScreen());
      case AppRouteNames.webstoreMain:
        return MaterialPageRoute(builder: (_) => const WebStoreMainLayout());
      case AppRouteNames.webstoreCheckout:
        return MaterialPageRoute(builder: (_) => const WebStoreCheckoutView());
      case AppRouteNames.webstoreOrderTrack:
        return MaterialPageRoute(builder: (_) => const WebStoreOrderTrackView());
      case AppRouteNames.webstoreRateOrder:
        return MaterialPageRoute(builder: (_) => const WebStoreRateOrderView());
      case AppRouteNames.webstoreOrderList:
        return MaterialPageRoute(builder: (_) => const WebStoreOrderListView());
      case AppRouteNames.webstoreOrderDetails:
        return MaterialPageRoute(builder: (_) => const WebStoreOrderDetailsView());
      case AppRouteNames.webstoreWishlist:
        return MaterialPageRoute(builder: (_) => const WebStoreWishlistView());
      case AppRouteNames.webstorePoints:
        return MaterialPageRoute(builder: (_) => const WebStorePointsView());

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
