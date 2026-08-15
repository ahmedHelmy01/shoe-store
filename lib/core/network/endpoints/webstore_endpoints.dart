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
  final String points = '/api/store/points';
  final String loyaltySummary = '/api/store/loyalty/summary';
  final String loyaltyPreview = '/api/store/loyalty/preview';
  final String governorates = '/api/store/governorates';
  final String cities = '/api/store/cities';

  // ─── Wishlist & Upload ─────────────────────────────────────
  final wishlist = const _WebStoreWishlist();
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
  String productReviews(int productId) => '/api/store/products/$productId/reviews';
}

class _WebStoreCart {
  const _WebStoreCart();
  final String index = '/api/store/cart';
  final String items = '/api/store/cart/items';
  String itemDetail(int itemId) => '/api/store/cart/items/$itemId';
  String reorder(int orderId) => '/api/store/cart/reorder/$orderId';
}

class _WebStoreCheckout {
  const _WebStoreCheckout();
  final String validate = '/api/store/checkout/validate';
  final String calculate = '/api/store/checkout/calculate';
  final String placeOrder = '/api/store/checkout/place-order';
}

class _WebStoreOrders {
  const _WebStoreOrders();
  final String index = '/api/store/orders';
  final String detail = '/api/store/orders/{id}';
  final String cancel = '/api/store/orders/{id}/cancel';
  final String returnOrder = '/api/store/orders/{id}/return';
  final String track = '/api/store/orders/{id}/track';
  final String reorder = '/api/store/orders/{id}/reorder';
  final String rate = '/api/store/orders/{id}/rate';
  final String rating = '/api/store/orders/{id}/rating';
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
  final String add = '/api/store/wishlist';
  final String remove = '/api/store/wishlist';
}





class _WebStoreUpload {
  const _WebStoreUpload();

  final String single = '/api/store/upload';
  final String multiple = '/api/store/upload/multi';
  final String delete = '/api/store/upload/delete';
}

