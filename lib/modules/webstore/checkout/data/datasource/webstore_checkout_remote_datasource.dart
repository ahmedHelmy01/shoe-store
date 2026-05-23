/// WebStore Checkout Remote DataSource
///
/// Checkout HTTP calls: validate, calculate, and place-order.
library;

import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class WebStoreCheckoutRemoteDataSource {
  final NetworkService _networkService;

  WebStoreCheckoutRemoteDataSource(this._networkService);

  /// POST /api/store/checkout/validate — Validate cart for checkout
  Future<dynamic> validateCart() {
    return _networkService.post(ApiEndpoints.webstore.checkout.validate);
  }

  /// POST /api/store/checkout/calculate — Calculate checkout totals
  Future<dynamic> calculateTotals(Map<String, dynamic> data) {
    return _networkService.post(
      ApiEndpoints.webstore.checkout.calculate,
      body: data,
    );
  }

  /// POST /api/store/checkout/place-order — Place an order
  Future<dynamic> placeOrder(Map<String, dynamic> data) {
    return _networkService.post(
      ApiEndpoints.webstore.checkout.placeOrder,
      body: data,
    );
  }

  /// POST /api/store/coupons/validate — Validate a coupon
  Future<dynamic> validateCoupon(String code) {
    return _networkService.post(
      '/api/store/coupons/validate',
      body: {'code': code},
    );
  }

  /// GET /api/store/payment-methods — Get active payment methods
  Future<dynamic> getPaymentMethods() {
    return _networkService.get('/api/store/payment-methods');
  }
}
