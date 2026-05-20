/// WebStore Catalog Remote DataSource
///
/// Catalog-only HTTP calls to WebStore API endpoints using NetworkService.
library;

import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class WebStoreCatalogRemoteDataSource {
  final NetworkService _networkService;

  WebStoreCatalogRemoteDataSource(this._networkService);

  Future<dynamic> getProducts({Map<String, dynamic>? queryParams}) {
    return _networkService.get(
      ApiEndpoints.webstore.catalog.products,
      query: queryParams,
    );
  }

  Future<dynamic> getProductDetail(int id) {
    return _networkService.get(
      ApiEndpoints.withId(ApiEndpoints.webstore.catalog.productDetail, id),
    );
  }

  Future<dynamic> getCategories({Map<String, dynamic>? queryParams}) {
    return _networkService.get(
      ApiEndpoints.webstore.catalog.categoryTree,
      query: queryParams,
    );
  }

  Future<dynamic> getCategoryDetail(int id) {
    return _networkService.get(
      ApiEndpoints.withId(ApiEndpoints.webstore.catalog.categoryDetail, id),
    );
  }

  Future<dynamic> searchProducts(String query) {
    return _networkService.get(
      ApiEndpoints.webstore.catalog.search,
      query: {'q': query},
    );
  }

  Future<dynamic> getManufacturers() {
    return _networkService.get('/api/store/manufacturers');
  }

  Future<dynamic> getTags() {
    return _networkService.get('/api/store/tags');
  }

  // ─── Wishlist (kept under Catalog domain) ───────────

  Future<dynamic> getWishlist() {
    return _networkService.get(ApiEndpoints.webstore.wishlist.index);
  }

  Future<dynamic> addToWishlist(int productId) {
    return _networkService.post(
      ApiEndpoints.webstore.wishlist.add,
      body: {'product_id': productId},
    );
  }

  Future<dynamic> removeFromWishlist(int productId) {
    return _networkService.delete(
      ApiEndpoints.withId(ApiEndpoints.webstore.wishlist.remove, productId),
    );
  }
}
