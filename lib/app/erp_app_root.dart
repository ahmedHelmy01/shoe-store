import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/app/app_initializer.dart';
import 'package:erp/core/constants/configure_system_ui.dart';
import 'package:erp/core/config/app_flavor.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/providers/theme_provider.dart';
import 'package:erp/core/theme/app_theme.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/router/route_generator.dart';
import 'package:erp/app/splash_router.dart';
import 'package:erp/core/network/network_check_internet.dart';
import 'package:erp/core/common_widget/network_listener.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:erp/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    ref.watch(networkStatusProvider);

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
          return MaterialApp(
            title: FlavorConfig.appName,
            debugShowCheckedModeBanner: false,
            navigatorKey: AppNavigator.navigatorKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ref.watch(themeProvider),
            home: const SplashRouter(),
            onGenerateRoute: RouteGenerator.onGenerateRoute,
            // Use builder to inject NetworkListener so it has access to Directionality
            builder: (context, child) {
              return NetworkListener(child: child!);
            },
          );
        },
      ),
    );
  }
}

/// Global dynamic bootstrap function
Future<void> bootstrap(AppFlavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  configureSystemUI();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GoogleSignIn.instance.initialize(
    serverClientId: '364936943793-6gp5u8ceave53mcmdgvtb87sjv95j62g.apps.googleusercontent.com',
  );
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
