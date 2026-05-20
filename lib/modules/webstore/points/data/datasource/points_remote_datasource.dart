import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class PointsRemoteDataSource {
  final NetworkService _networkService;

  PointsRemoteDataSource(this._networkService);

  Future<dynamic> getPoints() {
    return _networkService.get(ApiEndpoints.webstore.points);
  }
}
