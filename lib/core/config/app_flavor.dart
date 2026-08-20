/// App Flavor Configuration for Modular ERP System
enum AppFlavor {

  webstore, // متجر الويب

}

extension AppFlavorExt on AppFlavor {
  String get configPath {
    return switch (this) {

      AppFlavor.webstore => 'assets/config/config_webstore.json',

    };
  }

  String get appName {
    return switch (this) {

      AppFlavor.webstore => 'متجر الويب',

    };
  }

  String get defaultInitialPath {
    return '/splash';
  }

  /// Features enabled for each flavor
  List<String> get enabledFeatures {
    return switch (this) {

      AppFlavor.webstore => ['auth', 'webstore', 'cart', 'profile'],

    };
  }

  bool hasFeature(String feature) => enabledFeatures.contains(feature);
}

class FlavorConfig {
  static late AppFlavor appFlavor;

  static void init(AppFlavor flavor) {
    appFlavor = flavor;
  }

  static String get appName => appFlavor.appName;
  static List<String> get enabledFeatures => appFlavor.enabledFeatures;
  static bool hasFeature(String feature) => appFlavor.hasFeature(feature);

  static bool get isWebStore => appFlavor == AppFlavor.webstore;
}
