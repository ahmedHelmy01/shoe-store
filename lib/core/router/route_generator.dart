import 'package:erp/modules/webstore/admin/core/admin_routes.dart';
import 'package:erp/modules/webstore/admin/core/admin_shell.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
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
import 'package:erp/modules/webstore/points/presentation/view/webstore_points_view.dart';
import 'package:erp/modules/webstore/pages/presentation/view/webstore_page_view.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/products/catalog_products_view.dart';

// Models for type casting in arguments

class RouteGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.webstoreLogin:
        return MaterialPageRoute(builder: (_) => const WebStoreLoginScreen());
      case AppRouteNames.webstoreRegister:
        return MaterialPageRoute(
          builder: (_) => const WebStoreRegisterScreen(),
        );
      case AppRouteNames.webstoreForgotPassword:
        return MaterialPageRoute(
          builder: (_) => const WebStoreForgotPasswordScreen(),
        );
      case AppRouteNames.webstoreOtp:
        final args = (settings.arguments is Map)
            ? (settings.arguments as Map)
            : const <String, dynamic>{};
        final identifier = args['identifier'] as String?;
        final type = args['type'] as String?;
        if (identifier == null || type == null) return _errorRoute();
        return MaterialPageRoute(
          builder: (_) => WebStoreOtpScreen(identifier: identifier, type: type),
        );
      case AppRouteNames.webstoreResetPassword:
        final args = (settings.arguments is Map)
            ? (settings.arguments as Map)
            : const <String, dynamic>{};
        final identifier = args['identifier'] as String?;
        final code = args['code'] as String?;
        if (identifier == null || code == null) return _errorRoute();
        return MaterialPageRoute(
          builder: (_) =>
              WebStoreResetPasswordScreen(identifier: identifier, code: code),
        );
      case AppRouteNames.webstoreMain:
        final args = (settings.arguments is Map)
            ? (settings.arguments as Map)
            : const <String, dynamic>{};
        final initialIndex = args['initialIndex'] as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => WebStoreMainLayout(initialIndex: initialIndex),
        );
      case AppRouteNames.webstoreCheckout:
        return _guarded(const WebStoreCheckoutView());
      case AppRouteNames.webstoreOrderTrack:
        return _guarded(const WebStoreOrderTrackView());
      case AppRouteNames.webstoreRateOrder:
        return _guarded(const WebStoreRateOrderView());
      case AppRouteNames.webstoreOrderList:
        return _guarded(const WebStoreOrderListView());
      case AppRouteNames.webstoreOrderDetails:
        return _guarded(const WebStoreOrderDetailsView());
      case AppRouteNames.webstoreWishlist:
        return _guarded(const WebStoreWishlistView());
      case AppRouteNames.webstorePoints:
        return _guarded(const WebStorePointsView());
      case AppRouteNames.webstorePage:
        final args = (settings.arguments is Map)
            ? (settings.arguments as Map)
            : const <String, dynamic>{};
        final slug = args['slug'] as String?;
        final title = args['title'] as String?;
        if (slug == null || title == null) return _errorRoute();
        return MaterialPageRoute(
          builder: (_) => WebStorePageView(slug: slug, initialTitle: title),
        );
      case AppRouteNames.webstoreCatalogProducts:
        final args = (settings.arguments is Map)
            ? (settings.arguments as Map)
            : const <String, dynamic>{};
        final preset = args['preset'] as String?;
        final categoryIdArg = args['category_id'];
        final int? initialCategoryId = switch (categoryIdArg) {
          int v => v,
          num v => v.toInt(),
          String v => int.tryParse(v),
          _ => null,
        };
        final categoryTitle = args['category_title'] as String?;
        return MaterialPageRoute(
          builder: (_) => CatalogProductsView(
            initialPreset: preset,
            initialCategoryId: initialCategoryId,
            initialScreenTitle: categoryTitle,
          ),
        );

      // ─── WebStore Admin ─────────────────────────────
      default:
        if (settings.name != null &&
            settings.name!.startsWith(AppRouteNames.webstoreAdmin)) {
          final id = AdminRoutes.fromRouteName(settings.name);
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => AdminShell(initial: id),
          );
        }
        return _errorRoute();
    }
  }

  static Route<dynamic> _guarded(Widget child) {
    return MaterialPageRoute(
      builder: (context) {
        final auth = ProviderScope.containerOf(context).read(authStateProvider);
        final isAuthed = auth.status == AuthStatus.authenticated;
        return isAuthed ? child : const WebStoreLoginScreen();
      },
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(LocaleKeys.common.error.tr(context: context)),
          ),
          body: Center(
            child: Text(LocaleKeys.common.page_not_found.tr(context: context)),
          ),
        );
      },
    );
  }
}
