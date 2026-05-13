/// WebStore Endpoints
///
/// Hierarchical endpoints for the massive WebStore module (102+ endpoints).
library;

class WebStoreEndpoints {
  const WebStoreEndpoints();

  // ─── User Facing ───────────────────────────────────
  final auth = const _WebStoreAuth();
  final catalog = const _WebStoreCatalog();
  final cart = const _WebStoreCart();
  final checkout = const _WebStoreCheckout();
  final orders = const _WebStoreOrders();
  final profile = const _WebStoreProfile();
  final cms = const _WebStoreCms();

  // ─── Admin Facing ──────────────────────────────────
  final wishlist = const _WebStoreWishlist();
  final admin = const _WebStoreAdmin();
  final upload = const _WebStoreUpload();
}

class _WebStoreAuth {
  const _WebStoreAuth();
  final String register = '/api/store/auth/register';
  final String login = '/api/store/auth/login';
  final String forgotPassword = '/api/store/auth/forgot-password';
  final String verifyCode = '/api/store/auth/verify-code';
  final String resendCode = '/api/store/auth/resend-code';
  final String socialLogin = '/api/store/auth/social-login';
  final String resetPassword = '/api/store/auth/reset-password';
  final String weekPoints = '/api/store/auth/week-points';
  final String refreshToken = '/api/store/auth/refresh-token';
  final String logout = '/api/store/auth/logout';
}

class _WebStoreCatalog {
  const _WebStoreCatalog();
  final String products = '/api/store/products';
  final String productDetail = '/api/store/products/{id}';
  final String categories = '/api/store/categories';
  final String categoryTree = '/api/store/categories/tree';
  final String categoryDetail = '/api/store/categories/{id}';
  final String search = '/api/store/search';
  final String filters = '/api/store/properties';
}

class _WebStoreCart {
  const _WebStoreCart();
  final String index = '/api/store/cart';
  final String add = '/api/store/cart/add';
  final String update = '/api/store/cart/update';
  final String remove = '/api/store/cart/remove';
  final String clear = '/api/store/cart/clear';
  final String applyCoupon = '/api/store/cart/apply-coupon';
}

class _WebStoreCheckout {
  const _WebStoreCheckout();
  final String summary = '/api/store/checkout/summary';
  final String confirm = '/api/store/checkout/place-order';
}

class _WebStoreOrders {
  const _WebStoreOrders();
  final String index = '/api/store/orders';
  final String detail = '/api/store/orders/{id}';
  final String cancel = '/api/store/orders/{id}/cancel';
  final String returnOrder = '/api/store/orders/{id}/return';
  final String track = '/api/store/orders/{id}/track';
  final String reorder = '/api/store/orders/{id}/reorder';
}

class _WebStoreProfile {
  const _WebStoreProfile();
  final String profile = '/api/store/profile';
  final String update = '/api/store/profile/update';
  final String changePassword = '/api/store/profile/change-password';
  final String avatar = '/api/store/profile/avatar';
  final String addresses = '/api/store/addresses';
  final String createAddress = '/api/store/addresses/create';
  final String updateAddress = '/api/store/addresses/{id}';
  final String deleteAddress = '/api/store/addresses/{id}';
  final String defaultAddress = '/api/store/addresses/{id}/default';
}

class _WebStoreCms {
  const _WebStoreCms();
  final String sliders = '/api/store/sliders';
  final String ads = '/api/store/ads';
  final String coupons = '/api/store/coupons';
  final String boardings = '/api/store/boardings';
  final String pages = '/api/store/pages';
  final String pageDetail = '/api/store/pages/{slug}';
  final String settings = '/api/store/settings';
  final String branches = '/api/store/branches';
  final String contact = '/api/store/contact';
}

class _WebStoreWishlist {
  const _WebStoreWishlist();
  final String index = '/api/store/wishlist';
  final String add = '/api/store/wishlist/add';
  final String remove = '/api/store/wishlist/remove';
}

class _WebStoreAdmin {
  const _WebStoreAdmin();
  
  // Dashboard
  final String dashboard = '/api/store/admin/dashboard';
  final String statistics = '/api/store/admin/statistics';

  // Catalog
  final String products = '/api/store/admin/products';
  final String productsImport = '/api/store/admin/products/import';
  final String categories = '/api/store/admin/categories';
  final String properties = '/api/store/admin/properties';
  final String filters = '/api/store/admin/properties'; // Alias for compatibility
  final String companies = '/api/store/admin/manufacturers'; // Alias
  final String manufacturers = '/api/store/admin/manufacturers';
  final String tags = '/api/store/admin/tags';

  // CMS
  final String sliders = '/api/store/admin/sliders';
  final String ads = '/api/store/admin/ads';
  final String boardings = '/api/store/admin/boardings';
  final String pages = '/api/store/admin/pages';

  // Sales
  final String orders = '/api/store/admin/orders';
  final String orderStatuses = '/api/store/admin/order-statuses';
  String orderStatusUpdate(int id) => '/api/store/admin/orders/$id/status';

  // Localize
  final String governorates = '/api/store/admin/governorates';
  final String cities = '/api/store/admin/cities';
  final String countries = '/api/core/countries';


  // Configuration
  final String branches = '/api/store/admin/branches';
  final String warehouses = '/api/store/admin/warehouses';
  String warehouseReport(int id) => '/api/store/admin/warehouses/$id/report';
  final String paymentMethods = '/api/store/admin/payment-methods';
  final String paymentMethodTypes = '/api/store/admin/payment-methods/types';
  final String paymentStatuses = '/api/store/admin/payment-statuses';

  final String settings = '/api/store/admin/settings';

  // Customers
  final String clients = '/api/store/admin/clients';
  String clientAddresses(dynamic customerId) => '/api/store/admin/clients/$customerId/addresses';
  final String addresses = '/api/store/admin/addresses';
  final String customerGroups = '/api/store/admin/customer-groups';

  // Marketing
  final String coupons = '/api/store/admin/coupons';

  // Other
  final String contacts = '/api/store/admin/contacts';
}

class _WebStoreUpload {
  const _WebStoreUpload();

  final String single = '/api/store/upload';
  final String multiple = '/api/store/upload/multi';
  final String delete = '/api/store/upload/delete';
}
