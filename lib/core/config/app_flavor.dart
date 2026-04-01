/// App Flavor Configuration for Modular ERP System
enum AppFlavor {
  representatives, // نظام المناديب
  accounts, // نظام الحسابات
  employees, // نظام الموظفين
  webstore, // متجر الويب
  sales, // المبيعات
  purchases, // المشتريات
  inventory, // المخازن
  hrm, // الموارد البشرية
  accounting, // المحاسبة
  lis, // المختبرات
  pos, // نقاط البيع
  production, // الإنتاج
  crm, // علاقات العملاء
  cmms, // الصيانة
  qms, // الجودة
  full, // النظام الكامل
}

extension AppFlavorExt on AppFlavor {
  String get configPath {
    return switch (this) {
      AppFlavor.representatives => 'assets/config/config_representatives.json',
      AppFlavor.accounts => 'assets/config/config_accounts.json',
      AppFlavor.employees => 'assets/config/config_employees.json',
      AppFlavor.webstore => 'assets/config/config_webstore.json',
      AppFlavor.sales => 'assets/config/config_sales.json',
      AppFlavor.purchases => 'assets/config/config_purchases.json',
      AppFlavor.inventory => 'assets/config/config_inventory.json',
      AppFlavor.hrm => 'assets/config/config_hrm.json',
      AppFlavor.accounting => 'assets/config/config_accounting.json',
      AppFlavor.lis => 'assets/config/config_lis.json',
      AppFlavor.pos => 'assets/config/config_pos.json',
      AppFlavor.production => 'assets/config/config_production.json',
      AppFlavor.crm => 'assets/config/config_crm.json',
      AppFlavor.cmms => 'assets/config/config_cmms.json',
      AppFlavor.qms => 'assets/config/config_qms.json',
      AppFlavor.full => 'assets/config/config_full.json',
    };
  }

  String get appName {
    return switch (this) {
      AppFlavor.representatives => 'نظام المناديب',
      AppFlavor.accounts => 'نظام الحسابات',
      AppFlavor.employees => 'نظام الموظفين',
      AppFlavor.webstore => 'متجر الويب',
      AppFlavor.sales => 'نظام المبيعات',
      AppFlavor.purchases => 'نظام المشتريات',
      AppFlavor.inventory => 'نظام المخازن',
      AppFlavor.hrm => 'نظام الموارد البشرية',
      AppFlavor.accounting => 'نظام المحاسبة',
      AppFlavor.lis => 'نظام المختبرات',
      AppFlavor.pos => 'نقاط البيع',
      AppFlavor.production => 'نظام الإنتاج',
      AppFlavor.crm => 'علاقات العملاء',
      AppFlavor.cmms => 'نظام الصيانة',
      AppFlavor.qms => 'نظام الجودة',
      AppFlavor.full => 'نظام ERP الشامل',
    };
  }

  String get defaultInitialPath {
    return '/splash';
  }

  /// Features enabled for each flavor
  List<String> get enabledFeatures {
    return switch (this) {
      AppFlavor.representatives => ['auth', 'representatives', 'invoices', 'reports'],
      AppFlavor.accounts => ['auth', 'accounts', 'reports'],
      AppFlavor.employees => ['auth', 'employees', 'reports'],
      AppFlavor.webstore => ['auth', 'webstore', 'cart', 'profile'],
      AppFlavor.sales => ['auth', 'sales', 'customers', 'invoices'],
      AppFlavor.purchases => ['auth', 'purchases', 'suppliers', 'invoices'],
      AppFlavor.inventory => ['auth', 'inventory', 'warehouses', 'stock'],
      AppFlavor.hrm => ['auth', 'hrm', 'employees', 'payroll'],
      AppFlavor.accounting => ['auth', 'accounting', 'journals', 'ledgers'],
      AppFlavor.lis => ['auth', 'lis', 'labs', 'results'],
      AppFlavor.pos => ['auth', 'pos', 'sales', 'retail'],
      AppFlavor.production => ['auth', 'production', 'orders', 'factory'],
      AppFlavor.crm => ['auth', 'crm', 'leads', 'deals'],
      AppFlavor.cmms => ['auth', 'cmms', 'maintenance', 'assets'],
      AppFlavor.qms => ['auth', 'qms', 'quality', 'audit'],
      AppFlavor.full => [
        'auth',
        'webstore',
        'sales',
        'purchases',
        'inventory',
        'hrm',
        'accounting',
        'lis',
        'pos',
        'production',
        'crm',
        'cmms',
        'qms',
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
