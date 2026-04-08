import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/app/app_initializer.dart';
import 'package:erp/core/config/app_flavor.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/providers/theme_provider.dart';
import 'package:erp/core/theme/app_theme.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/common_widget/main_layout/webstore_main_layout.dart';
import 'package:erp/modules/webstore/onboarding/onboarding_view.dart';
import 'package:erp/modules/webstore/splash/animated_splash_screen.dart';
import 'package:erp/modules/webstore/checkout/presentation/view/webstore_checkout_view.dart';
import 'package:erp/modules/webstore/orders/presentation/view/webstore_order_track_view.dart';
import 'package:erp/modules/webstore/orders/presentation/view/webstore_rate_order_view.dart';
import 'package:erp/modules/webstore/orders/presentation/view/webstore_order_list_view.dart';
import 'package:erp/modules/webstore/orders/presentation/view/webstore_order_details_view.dart';
import 'package:erp/modules/webstore/wishlist/presentation/view/webstore_wishlist_view.dart';
import 'package:erp/modules/webstore/profile/presentation/view/webstore_points_view.dart';

/// Central entry point for the ERP application
class ErpAppRoot extends ConsumerStatefulWidget {
  const ErpAppRoot({super.key});

  @override
  ConsumerState<ErpAppRoot> createState() => _ErpAppRootState();
}

class _ErpAppRootState extends ConsumerState<ErpAppRoot> {
  Locale? _startLocale;

  @override
  void initState() {  
    super.initState();
    _loadStartLocale();
  }

  Future<void> _loadStartLocale() async {
    final code = await ref.read(sessionManagerProvider).getLocale();
    if (!mounted) return;
    setState(() => _startLocale = Locale(code));
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(isConnectedProvider);

    // Avoid building the app with the wrong locale for 1 frame.
    if (_startLocale == null) {
      return const SizedBox.shrink();
    }

    return EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: AppConstants.translationPath,
      fallbackLocale: const Locale('ar'),
      startLocale: _startLocale,
      saveLocale: true,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Builder(
            builder: (context) {
              return MaterialApp(
                title: FlavorConfig.appName,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: ref.watch(themeProvider),
                home: const SplashRouter(),
                routes: {
                  AppRouteNames.webstoreMain: (context) => const WebStoreMainLayout(),
                  AppRouteNames.webstoreCheckout: (context) => const WebStoreCheckoutView(),
                  AppRouteNames.webstoreOrderTrack: (context) => const WebStoreOrderTrackView(),
                  AppRouteNames.webstoreRateOrder: (context) => const WebStoreRateOrderView(),
                  AppRouteNames.webstoreOrderList: (context) => const WebStoreOrderListView(),
                  AppRouteNames.webstoreOrderDetails: (context) => const WebStoreOrderDetailsView(),
                  AppRouteNames.webstoreWishlist: (context) => const WebStoreWishlistView(),
                  AppRouteNames.webstorePoints: (context) => const WebStorePointsView(),
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// Splash → Onboarding (first time) → Main Layout
class SplashRouter extends ConsumerStatefulWidget {
  const SplashRouter({super.key});

  @override
  ConsumerState<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends ConsumerState<SplashRouter> {
  bool _splashDone = false;
  bool? _isOnboardingDone;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final status = await ref.read(sessionManagerProvider).hasSeenOnboarding();
    if (mounted) {
      setState(() => _isOnboardingDone = status);
    }
  }

  void _onSplashComplete() {
    if (!mounted) return;
    setState(() => _splashDone = true);
  }

  @override
  Widget build(BuildContext context) {
    // ─── 1. Show Splash until animation is done ───────────
    if (!_splashDone || _isOnboardingDone == null) {
      return AnimatedSplashScreen(
        key: const ValueKey('splash'), 
        onComplete: _onSplashComplete,
      );
    }

    // ─── 2. Route based on Onboarding status ──────────────
    if (!(_isOnboardingDone!)) {
      return const OnBoarding(key: ValueKey('onboarding'));
    } else {
      return const WebStoreMainLayout(key: ValueKey('main'));
    }
  }
}

/// Global dynamic bootstrap function
Future<void> bootstrap(AppFlavor flavor) async {
  final prefs = await AppInitializer.init(flavor);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const ErpAppRoot(),
    ),
  );
}
