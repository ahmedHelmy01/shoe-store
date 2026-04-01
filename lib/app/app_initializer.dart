/// ERP System - App Initializer
///
/// Handles the critical bootstrap sequence before the app is displayed.
/// All async initializations like SharedPreferences or database setup happen here.
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:erp/core/config/app_flavor.dart';
import 'package:erp/core/config/app_config_manager.dart';

class AppInitializer {
  AppInitializer._();

  static Future<SharedPreferences> init(AppFlavor flavor) async {
    // 1. Flutter bindings
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    
    // 2. Preserve splash screen until initialization is complete
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // 3. Easy Localization init
    await EasyLocalization.ensureInitialized();

    // 4. Initialize Flavor Config
    FlavorConfig.init(flavor);

    // 5. Load App Config from file
    await AppConfigManager.loadFromFile(flavor.configPath, flavor);

    // 6. Initialize SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // 7. Cleanup splash (will be manually removed later)
    FlutterNativeSplash.remove();

    return prefs;
  }
}
