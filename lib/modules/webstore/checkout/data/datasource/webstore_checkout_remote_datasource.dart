/// WebStore Checkout Remote DataSource
///
/// Checkout-only HTTP calls to WebStore API endpoints using NetworkService.
library;

import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class WebStoreCheckoutRemoteDataSource {
  final NetworkService _networkService;

  WebStoreCheckoutRemoteDataSource(this._networkService);

  Future<dynamic> getCheckoutSummary() {
    return _networkService.get(ApiEndpoints.webstore.checkout.summary);
  }

  Future<dynamic> placeOrder(Map<String, dynamic> data) {
    return _networkService.post(ApiEndpoints.webstore.checkout.confirm, body: data);
  }
}

