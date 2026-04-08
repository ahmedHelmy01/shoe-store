/// WebStore Remote DataSource
///
/// Handles all HTTP calls to the WebStore API endpoints using NetworkService.
library;

import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class WebStoreRemoteDataSource {
  final NetworkService _networkService;

  WebStoreRemoteDataSource(this._networkService);

  // ─── Catalog ───────────────────────────────────────

  Future<dynamic> getProducts({
    Map<String, dynamic>? queryParams,
  }) {
    return _networkService.get(
      ApiEndpoints.webstore.catalog.products,
      query: queryParams,
    );
  }

  Future<dynamic> getProductDetail(int id) {
    return _networkService.get(ApiEndpoints.withId(ApiEndpoints.webstore.catalog.productDetail, id));
  }

  Future<dynamic> getCategories({
    Map<String, dynamic>? queryParams,
  }) {
    return _networkService.get(
      ApiEndpoints.webstore.catalog.categories,
      query: queryParams,
    );
  }

  Future<dynamic> getCategoryDetail(int id) {
    return _networkService.get(ApiEndpoints.withId(ApiEndpoints.webstore.catalog.categoryDetail, id));
  }

  Future<dynamic> searchProducts(String query) {
    return _networkService.get(
      ApiEndpoints.webstore.catalog.search,
      query: {'q': query},
    );
  }

  // ─── Cart ──────────────────────────────────────────

  Future<dynamic> getCart() {
    return _networkService.get(ApiEndpoints.webstore.cart.index);
  }

  Future<dynamic> addToCart(Map<String, dynamic> data) {
    return _networkService.post(ApiEndpoints.webstore.cart.add, body: data);
  }

  Future<dynamic> updateCart(Map<String, dynamic> data) {
    return _networkService.put(ApiEndpoints.webstore.cart.update, body: data);
  }

  Future<dynamic> removeFromCart(Map<String, dynamic> data) {
    return _networkService.delete(ApiEndpoints.webstore.cart.remove, body: data);
  }

  Future<dynamic> clearCart() {
    return _networkService.delete(ApiEndpoints.webstore.cart.clear);
  }

  Future<dynamic> applyCoupon(String code) {
    return _networkService.post(ApiEndpoints.webstore.cart.applyCoupon, body: {'code': code});
  }

  // ─── Checkout ──────────────────────────────────────

  Future<dynamic> getCheckoutSummary() {
    return _networkService.get(ApiEndpoints.webstore.checkout.summary);
  }

  Future<dynamic> placeOrder(Map<String, dynamic> data) {
    return _networkService.post(ApiEndpoints.webstore.checkout.confirm, body: data);
  }

  // ─── Orders ────────────────────────────────────────

  Future<dynamic> getOrders({
    Map<String, dynamic>? queryParams,
  }) {
    return _networkService.get(ApiEndpoints.webstore.orders.index, query: queryParams);
  }

  Future<dynamic> getOrderDetail(int id) {
    return _networkService.get(ApiEndpoints.withId(ApiEndpoints.webstore.orders.detail, id));
  }

  Future<dynamic> cancelOrder(int id) {
    return _networkService.post(ApiEndpoints.withId(ApiEndpoints.webstore.orders.cancel, id));
  }

  Future<dynamic> trackOrder(int id) {
    return _networkService.get(ApiEndpoints.withId(ApiEndpoints.webstore.orders.track, id));
  }

  // ─── Wishlist ──────────────────────────────────────

  Future<dynamic> getWishlist() {
    return _networkService.get(ApiEndpoints.webstore.wishlist.index);
  }

  Future<dynamic> addToWishlist(int productId) {
    return _networkService.post(ApiEndpoints.webstore.wishlist.add, body: {'product_id': productId});
  }

  Future<dynamic> removeFromWishlist(int productId) {
    return _networkService.delete(ApiEndpoints.webstore.wishlist.remove, body: {'product_id': productId});
  }

  // ─── Profile & Addresses ───────────────────────────

  Future<dynamic> getProfile() {
    return _networkService.get(ApiEndpoints.webstore.profile.get);
  }

  Future<dynamic> updateProfile(Map<String, dynamic> data) {
    return _networkService.put(ApiEndpoints.webstore.profile.update, body: data);
  }

  Future<dynamic> getAddresses() {
    return _networkService.get(ApiEndpoints.webstore.profile.addresses);
  }

  Future<dynamic> createAddress(Map<String, dynamic> data) {
    return _networkService.post(ApiEndpoints.webstore.profile.createAddress, body: data);
  }

  Future<dynamic> updateAddress(int id, Map<String, dynamic> data) {
    return _networkService.put(ApiEndpoints.withId(ApiEndpoints.webstore.profile.updateAddress, id), body: data);
  }

  Future<dynamic> deleteAddress(int id) {
    return _networkService.delete(ApiEndpoints.withId(ApiEndpoints.webstore.profile.deleteAddress, id));
  }

  // ─── CMS & Promotional ────────────────────────────

  Future<dynamic> getSliders() {
    return _networkService.get(ApiEndpoints.webstore.cms.sliders);
  }

  Future<dynamic> getAds() {
    return _networkService.get(ApiEndpoints.webstore.cms.ads);
  }

  Future<dynamic> getBoardings() {
    return _networkService.get(ApiEndpoints.webstore.cms.boardings);
  }

  Future<dynamic> getPages() {
    return _networkService.get(ApiEndpoints.webstore.cms.pages);
  }

  Future<dynamic> getPageBySlug(String slug) {
    return _networkService.get(ApiEndpoints.withSlug(ApiEndpoints.webstore.cms.pageDetail, slug));
  }

  Future<dynamic> getSettings() {
    return _networkService.get(ApiEndpoints.webstore.cms.settings);
  }

  Future<dynamic> getBranches() {
    return _networkService.get(ApiEndpoints.webstore.cms.branches);
  }

  Future<dynamic> submitContact(Map<String, dynamic> data) {
    return _networkService.post(ApiEndpoints.webstore.cms.contact, body: data);
  }
}
