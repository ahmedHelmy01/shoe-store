/// App Flavor Configuration for Modular ERP System
enum AppFlavor {
  representatives, // نظام المناديب
  accounts, // نظام الحسابات
  employees, // نظام الموظفين
  full, // النظام الكامل
}

extension AppFlavorExt on AppFlavor {
  String get configPath {
    return switch (this) {
      AppFlavor.representatives => 'assets/config/config_representatives.json',
      AppFlavor.accounts => 'assets/config/config_accounts.json',
      AppFlavor.employees => 'assets/config/config_employees.json',
      AppFlavor.full => 'assets/config/config_full.json',
    };
  }

  String get appName {
    return switch (this) {
      AppFlavor.representatives => 'نظام المناديب',
      AppFlavor.accounts => 'نظام الحسابات',
      AppFlavor.employees => 'نظام الموظفين',
      AppFlavor.full => 'نظام ERP',
    };
  }

  String get defaultInitialPath {
    return '/splash';
  }

  /// Features enabled for each flavor
  List<String> get enabledFeatures {
    return switch (this) {
      AppFlavor.representatives => [
        'auth',
        'representatives',
        'invoices',
        'reports',
      ],
      AppFlavor.accounts => ['auth', 'accounts', 'reports'],
      AppFlavor.employees => ['auth', 'employees', 'reports'],
      AppFlavor.full => [
        'auth',
        'representatives',
        'accounts',
        'employees',
        'inventory',
        'invoices',
        'reports',
        'settings',
      ],
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

  static bool get isRepresentatives => appFlavor == AppFlavor.representatives;
  static bool get isAccounts => appFlavor == AppFlavor.accounts;
  static bool get isEmployees => appFlavor == AppFlavor.employees;
  static bool get isFull => appFlavor == AppFlavor.full;
}
