import 'app_flavor.dart';
import 'assets_config.dart';
import 'theme_config.dart';
import 'custom_settings.dart';
import 'firebase_config.dart';
import 'nav_bar_config.dart';

class AppConfig {
  final AppFlavor flavor;
  final String appName;
  final String appVersion;
  final String bundleId;
  final String baseURL;
  final String selectedTheme;
  final CustomSettings customSettings;
  final AssetsConfig assets;
  final CustomThemeConfig? customTheme;
  final FirebaseConfig fireBaseConfig;
  final List<BottomNavItemConfig> bottomNavItems;

  final String initialScreen;

  final List<String> enabledScreens;

  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.appVersion,
    required this.bundleId,
    required this.baseURL,
    required this.assets,
    required this.selectedTheme,
    required this.fireBaseConfig,
    this.customTheme,
    required this.customSettings,
    required this.bottomNavItems,
    required this.initialScreen,
    required this.enabledScreens,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json, AppFlavor flavor) {
    return AppConfig(
      flavor: flavor,
      appName: json['appName'],
      appVersion: json['appVersion'],
      bundleId: json['bundleId'],
      baseURL: json['baseURL'],
      selectedTheme: json['selectedTheme'],
      assets: AssetsConfig.fromJson(json['assets']),
      customTheme: json['customTheme'] != null
          ? CustomThemeConfig.fromJson(json['customTheme'])
          : null,
      fireBaseConfig: FirebaseConfig.fromJson(json['fireBaseConfig']),
      customSettings: CustomSettings.fromJson(json['customSettings']),
      bottomNavItems: (json['bottomNavItems'] as List)
          .map((e) => BottomNavItemConfig.fromJson(e))
          .toList(),
      initialScreen: json['initialScreen'] ?? "/splash",
      enabledScreens: (json['enabledScreens'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }
}

