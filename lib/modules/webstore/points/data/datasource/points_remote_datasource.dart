import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class PointsRemoteDataSource {
  final NetworkService _networkService;

  PointsRemoteDataSource(this._networkService);

  Future<dynamic> getPoints() {
    return _networkService.get(ApiEndpoints.webstore.points);
  }

  Future<dynamic> getLoyaltySummary() {
    return _networkService.get(ApiEndpoints.webstore.loyaltySummary);
  }

  Future<dynamic> previewLoyalty(Map<String, dynamic> body) {
    return _networkService.post(ApiEndpoints.webstore.loyaltyPreview, body: body);
  }
}
