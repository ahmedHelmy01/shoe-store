import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/app/app_initializer.dart';
import 'package:erp/core/config/app_flavor.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/theme/app_theme.dart';
import 'package:erp/core/constants/app_constants.dart';

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
      child: Builder(
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
      AuthStatus.authenticated => const Scaffold(body: Center(child: Text('Dashboard (Root)'))),
      AuthStatus.unauthenticated => const Scaffold(body: Center(child: Text('Login (Root)'))),
      AuthStatus.initial => const Scaffold(body: Center(child: CircularProgressIndicator())),
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
