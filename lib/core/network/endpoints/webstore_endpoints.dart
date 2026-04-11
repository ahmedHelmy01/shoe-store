/// WebStore Endpoints
///
/// Hierarchical endpoints for the massive WebStore module (102 endpoints).
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
  final String products = '/api/webstore/catalog/products';
  final String productDetail = '/api/webstore/catalog/products/{id}';
  final String categories = '/api/webstore/catalog/categories';
  final String categoryDetail = '/api/webstore/catalog/categories/{id}';
  final String search = '/api/webstore/catalog/search';
  final String filters = '/api/webstore/catalog/filters';
}

class _WebStoreCart {
  const _WebStoreCart();
  final String index = '/api/webstore/cart';
  final String add = '/api/webstore/cart/add';
  final String update = '/api/webstore/cart/update';
  final String remove = '/api/webstore/cart/remove';
  final String clear = '/api/webstore/cart/clear';
  final String applyCoupon = '/api/webstore/cart/apply-coupon';
}

class _WebStoreCheckout {
  const _WebStoreCheckout();
  final String summary = '/api/webstore/checkout/summary';
  final String confirm = '/api/webstore/checkout/confirm';
}

class _WebStoreOrders {
  const _WebStoreOrders();
  final String index = '/api/webstore/orders';
  final String detail = '/api/webstore/orders/{id}';
  final String cancel = '/api/webstore/orders/{id}/cancel';
  final String returnOrder = '/api/webstore/orders/{id}/return';
  final String track = '/api/webstore/orders/{id}/track';
  final String reorder = '/api/webstore/orders/{id}/reorder';
}

class _WebStoreProfile {
  const _WebStoreProfile();
  final String get = '/api/webstore/profile';
  final String update = '/api/webstore/profile/update';
  final String changePassword = '/api/webstore/profile/change-password';
  final String avatar = '/api/webstore/profile/avatar';
  final String addresses = '/api/webstore/addresses';
  final String createAddress = '/api/webstore/addresses/create';
  final String updateAddress = '/api/webstore/addresses/{id}';
  final String deleteAddress = '/api/webstore/addresses/{id}';
  final String defaultAddress = '/api/webstore/addresses/{id}/default';
}

class _WebStoreCms {
  const _WebStoreCms();
  final String sliders = '/api/store/sliders';
  final String ads = '/api/store/ads';
  final String boardings = '/api/store/boardings';
  final String pages = '/api/store/pages';
  final String pageDetail = '/api/store/pages/{slug}';
  final String settings = '/api/store/settings';
  final String branches = '/api/store/branches';
  final String contact = '/api/store/contact';
}

class _WebStoreWishlist {
  const _WebStoreWishlist();
  final String index = '/api/webstore/wishlist';
  final String add = '/api/webstore/wishlist/add';
  final String remove = '/api/webstore/wishlist/remove';
}

class _WebStoreAdmin {
  const _WebStoreAdmin();
  final String dashboard = '/api/webstore/admin/dashboard';
  final String products = '/api/webstore/admin/products';
  final String categories = '/api/webstore/admin/categories';
  final String orders = '/api/webstore/admin/orders';
  final String branches = '/api/store/admin/branches';
  final String coupons = '/api/store/admin/coupons';
  final String warehouses = '/api/store/admin/warehouses';
  final String sliders = '/api/store/admin/sliders';
  final String ads = '/api/store/admin/ads';
  final String boardings = '/api/store/admin/boardings';
  final String pages = '/api/store/admin/pages';
  final String properties = '/api/store/admin/properties';
  final String paymentStatuses = '/api/store/admin/payment-statuses';
  final String paymentMethods = '/api/store/admin/payment-methods';
  final String cities = '/api/store/admin/cities';
  final String governorates = '/api/store/admin/governorates';
}
