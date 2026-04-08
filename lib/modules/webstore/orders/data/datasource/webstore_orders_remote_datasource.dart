/// WebStore Orders Remote DataSource
///
/// Orders-only HTTP calls to WebStore API endpoints using NetworkService.
library;

import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class WebStoreOrdersRemoteDataSource {
  final NetworkService _networkService;

  WebStoreOrdersRemoteDataSource(this._networkService);

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
}

