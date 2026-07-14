import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class LoyaltyAdminRemoteDataSource {
  final NetworkService _networkService;

  LoyaltyAdminRemoteDataSource(this._networkService);

  Future<dynamic> getSettings() {
    return _networkService.get(ApiEndpoints.webstore.admin.loyaltySettings);
  }

  Future<dynamic> updateSettings(Map<String, dynamic> body) {
    return _networkService.put(
      ApiEndpoints.webstore.admin.loyaltySettings,
      body: body,
    );
  }

  Future<dynamic> getCustomerPoints(dynamic customerId) {
    return _networkService.get(
      ApiEndpoints.webstore.admin.clientPoints(customerId),
    );
  }

  Future<dynamic> adjustCustomerPoints(
    dynamic customerId,
    Map<String, dynamic> body,
  ) {
    return _networkService.post(
      ApiEndpoints.webstore.admin.adjustClientPoints(customerId),
      body: body,
    );
  }

  Future<dynamic> awardOrderPoints(dynamic orderId) {
    return _networkService.post(
      ApiEndpoints.webstore.admin.awardPoints(orderId),
    );
  }

  Future<dynamic> cancelOrderWithPoints(dynamic orderId) {
    return _networkService.post(
      ApiEndpoints.webstore.admin.cancelOrder(orderId),
    );
  }

  Future<dynamic> getReport(String endpoint, {Map<String, dynamic>? query}) {
    return _networkService.get(endpoint, query: query);
  }
}
