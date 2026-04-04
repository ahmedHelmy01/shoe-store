import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/app/app_initializer.dart';
import 'package:erp/core/config/app_flavor.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/theme/app_theme.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/modules/webstore/auth/presentation/view/webstore_login_screen.dart';
import 'package:erp/modules/webstore/auth/presentation/view/webstore_register_screen.dart';
import 'package:erp/modules/webstore/auth/presentation/view/webstore_forgot_password_screen.dart';
import 'package:erp/modules/webstore/auth/presentation/view/webstore_otp_screen.dart';
import 'package:erp/modules/webstore/auth/presentation/view/webstore_reset_password_screen.dart';
import 'package:erp/core/common_widget/main_layout/webstore_main_layout.dart';

/// Central entry point for the ERP application
class ErpAppRoot extends ConsumerWidget {
  const ErpAppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch connectivity status globally
    ref.watch(isConnectedProvider);

    return EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: AppConstants.translationPath,
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // Standard design size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Builder(
            builder: (context) {
              return MaterialApp(
                title: FlavorConfig.appName,
                debugShowCheckedModeBanner: false,

                // Localization
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,

                // Theme
                theme: AppTheme.lightTheme,

                // Initializing feature modules route guards and dashboard logic
                home: const SplashOrAuthWrapper(),

                // Named Routes
                routes: {
                  AppRouteNames.webstoreLogin: (context) =>
                      const WebStoreLoginScreen(),
                  AppRouteNames.webstoreRegister: (context) =>
                      const WebStoreRegisterScreen(),
                  AppRouteNames.webstoreForgotPassword: (context) =>
                      const WebStoreForgotPasswordScreen(),
                  AppRouteNames.webstoreMain: (context) =>
                      const WebStoreMainLayout(),
                },

                onGenerateRoute: (settings) {
                  if (settings.name == AppRouteNames.webstoreOtp) {
                    final args = settings.arguments as Map<String, dynamic>;
                    return MaterialPageRoute(
                      builder: (context) => WebStoreOtpScreen(
                        identifier: args['identifier'],
                        type: args['type'],
                      ),
                    );
                  }
                  if (settings.name == AppRouteNames.webstoreResetPassword) {
                    final args = settings.arguments as Map<String, dynamic>;
                    return MaterialPageRoute(
                      builder: (context) => WebStoreResetPasswordScreen(
                        identifier: args['identifier'],
                        code: args['code'],
                      ),
                    );
                  }
                  return null;
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// A wrapper to decide the initial screen based on auth status
class SplashOrAuthWrapper extends ConsumerWidget {
  const SplashOrAuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return switch (authState.status) {
      AuthStatus.authenticated => const WebStoreMainLayout(),
      AuthStatus.unauthenticated => FlavorConfig.isWebStore
          ? const WebStoreMainLayout()
          : const WebStoreLoginScreen(),
      AuthStatus.initial => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    };
  }
}

/// Global dynamic bootstrap function
Future<void> bootstrap(AppFlavor flavor) async {
  final prefs = await AppInitializer.init(flavor);

  runApp(
    ProviderScope(
      overrides: [
        // Injecting the initialized SharedPreferences instance
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const ErpAppRoot(),
    ),
  );
}
