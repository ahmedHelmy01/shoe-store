/// WebStore Cart Remote DataSource
///
/// Cart HTTP calls to WebStore API using the new items-based endpoints.
library;

import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class WebStoreCartRemoteDataSource {
  final NetworkService _networkService;

  WebStoreCartRemoteDataSource(this._networkService);

  /// GET /api/store/cart — Fetch the current cart
  Future<dynamic> getCart() {
    return _networkService.get(ApiEndpoints.webstore.cart.index);
  }

  /// POST /api/store/cart/items — Add item to cart
  Future<dynamic> addItem(Map<String, dynamic> data) {
    return _networkService.post(ApiEndpoints.webstore.cart.items, body: data);
  }

  /// PUT /api/store/cart/items/{item} — Update cart item quantity
  Future<dynamic> updateItem(int itemId, {required int quantity}) {
    return _networkService.put(
      ApiEndpoints.webstore.cart.itemDetail(itemId),
      body: {'quantity': quantity},
    );
  }

  /// DELETE /api/store/cart/items/{item} — Remove item from cart
  Future<dynamic> removeItem(int itemId) {
    return _networkService.delete(
      ApiEndpoints.webstore.cart.itemDetail(itemId),
    );
  }

  /// DELETE /api/store/cart — Clear all items from cart
  Future<dynamic> clearCart() {
    return _networkService.delete(ApiEndpoints.webstore.cart.index);
  }

  /// POST /api/store/cart/reorder/{order} — Reorder from previous order
  Future<dynamic> reorder(int orderId) {
    return _networkService.post(
      ApiEndpoints.webstore.cart.reorder(orderId),
    );
  }
}
