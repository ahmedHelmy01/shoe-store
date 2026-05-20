import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class WebStoreBranchRemoteDataSource {
  final NetworkService _networkService;

  WebStoreBranchRemoteDataSource(this._networkService);

  Future<dynamic> getBranches() {
    return _networkService.get(ApiEndpoints.webstore.cms.branches);
  }
}
