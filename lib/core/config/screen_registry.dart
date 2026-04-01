import 'screen_module.dart';

/// Screen Registry for ERP System
/// Add screens here as features are implemented
class ScreenRegistry {
  static final Map<String, ScreenModule> _modules = {
    // Splash Screen (will be added later)
    // "/splash": ScreenModule(path: "/splash", builder: (_) => const SplashScreen()),

    // Auth Screens (will be added later)
    // "/login": ScreenModule(path: "/login", builder: (_) => const LoginScreen()),
    // "/register": ScreenModule(path: "/register", builder: (_) => const RegisterScreen()),

    // Dashboard (will be added later)
    // "/dashboard": ScreenModule(path: "/dashboard", builder: (_) => const DashboardScreen()),

    // Sales Module (will be added later)
    // "/sales": ScreenModule(path: "/sales", builder: (_) => const SalesScreen()),
    // "/invoices": ScreenModule(path: "/invoices", builder: (_) => const InvoicesScreen()),

    // Purchases Module (will be added later)
    // "/purchases": ScreenModule(path: "/purchases", builder: (_) => const PurchasesScreen()),

    // Inventory Module (will be added later)
    // "/inventory": ScreenModule(path: "/inventory", builder: (_) => const InventoryScreen()),
    // "/products": ScreenModule(path: "/products", builder: (_) => const ProductsScreen()),

    // Reports Module (will be added later)
    // "/reports": ScreenModule(path: "/reports", builder: (_) => const ReportsScreen()),

    // Accounts Module (will be added later)
    // "/accounts": ScreenModule(path: "/accounts", builder: (_) => const AccountsScreen()),

    // Representatives Module (المناديب)
    // "/representatives": ScreenModule(path: "/representatives", builder: (_) => const RepresentativesScreen()),
  };

  static ScreenModule? get(String path) => _modules[path];

  static List<String> get availableRoutes => _modules.keys.toList();
}
