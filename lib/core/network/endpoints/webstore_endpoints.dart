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
  final String login = '/api/webstore/auth/login';
  final String register = '/api/webstore/auth/register';
  final String logout = '/api/webstore/auth/logout';
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
  final String sliders = '/api/webstore/cms/sliders';
  final String banners = '/api/webstore/cms/banners';
  final String ads = '/api/webstore/cms/ads';
  final String pages = '/api/webstore/cms/pages';
  final String pageDetail = '/api/webstore/cms/pages/{id}';
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
}
