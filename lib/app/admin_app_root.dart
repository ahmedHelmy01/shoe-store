import 'package:easy_localization/easy_localization.dart';
import 'package:erp/app/app_initializer.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/providers/theme_provider.dart';
import 'package:erp/core/theme/app_theme.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/config/app_flavor.dart';
import 'package:erp/modules/webstore/admin/core/admin_route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Standalone Admin entry point (web + mobile).
class AdminAppRoot extends ConsumerStatefulWidget {
  const AdminAppRoot({super.key});

  @override
  ConsumerState<AdminAppRoot> createState() => _AdminAppRootState();
}

class _AdminAppRootState extends ConsumerState<AdminAppRoot> {
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

    if (_startLocale == null) return const SizedBox.shrink();

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
          return MaterialApp(
            title: 'WebStore Admin',
            debugShowCheckedModeBanner: false,
            navigatorKey: AppNavigator.navigatorKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ref.watch(themeProvider),
            // IMPORTANT (Web F5 / deep-links):
            // Do not use `home:`; otherwise the app always starts at home and ignores route names.
            initialRoute: '/',
            onGenerateRoute: AdminRouteGenerator.onGenerateRoute,
          );
        },
      ),
    );
  }
}

Future<void> bootstrapAdmin() async {
  // Re-use webstore config for now (same base url, assets, etc).
  final prefs = await AppInitializer.init(AppFlavor.webstore);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const AdminAppRoot(),
    ),
  );
}

