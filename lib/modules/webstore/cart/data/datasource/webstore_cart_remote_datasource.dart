/// WebStore Cart Remote DataSource
///
/// Cart-only HTTP calls to WebStore API endpoints using NetworkService.
library;

import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class WebStoreCartRemoteDataSource {
  final NetworkService _networkService;

  WebStoreCartRemoteDataSource(this._networkService);

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
    return _networkService.post(
      ApiEndpoints.webstore.cart.applyCoupon,
      body: {'code': code},
    );
  }
}

