/// WebStore Orders Remote DataSource
///
/// Orders-only HTTP calls to WebStore API endpoints using NetworkService.
library;

import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class WebStoreOrdersRemoteDataSource {
  final NetworkService _networkService;

  WebStoreOrdersRemoteDataSource(this._networkService);

  /// GET /api/store/orders — List orders with optional pagination & filters
  Future<dynamic> getOrders({
    Map<String, dynamic>? queryParams,
  }) {
    return _networkService.get(ApiEndpoints.webstore.orders.index, query: queryParams);
  }

  /// GET /api/store/orders/{id} — Get full order details
  Future<dynamic> getOrderDetail(int id) {
    return _networkService.get(ApiEndpoints.withId(ApiEndpoints.webstore.orders.detail, id));
  }

  /// POST /api/store/orders/{id}/cancel — Cancel an order with optional reason
  Future<dynamic> cancelOrder(int id, {String? reason}) {
    return _networkService.post(
      ApiEndpoints.withId(ApiEndpoints.webstore.orders.cancel, id),
      body: reason != null ? {'reason': reason} : null,
    );
  }

  /// POST /api/store/orders/{id}/rate — Rate an order
  Future<dynamic> rateOrder(int id, {required int rating, String? ratingText}) {
    final body = <String, dynamic>{'rating': rating};
    if (ratingText != null && ratingText.isNotEmpty) {
      body['rating_text'] = ratingText;
    }
    return _networkService.post(
      ApiEndpoints.withId(ApiEndpoints.webstore.orders.rate, id),
      body: body,
    );
  }

  /// GET /api/store/orders/{id}/rating — Get order rating
  Future<dynamic> getOrderRating(int id) {
    return _networkService.get(ApiEndpoints.withId(ApiEndpoints.webstore.orders.rating, id));
  }

  /// GET /api/store/orders/{id}/track — Track order
  Future<dynamic> trackOrder(int id) {
    return _networkService.get(ApiEndpoints.withId(ApiEndpoints.webstore.orders.track, id));
  }
}
