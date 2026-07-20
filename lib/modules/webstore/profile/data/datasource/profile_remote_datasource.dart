import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class ProfileRemoteDataSource {
  final NetworkService _networkService;

  ProfileRemoteDataSource(this._networkService);

  Future<dynamic> getProfile() {
    return _networkService.get(
      ApiEndpoints.webstore.profile.profile,
    );
  }

  Future<dynamic> updateProfile({
    String? name,
    String? email,
    String? mobile,
    String? password,
    int? branchId,
  }) {
    return _networkService.put(
      ApiEndpoints.webstore.profile.profile,
      body: {
        'name': ?name,
        'email': ?email,
        'mobile': ?mobile,
        'password': ?password,
        'branch_id': ?branchId,
      },
    );
  }

  Future<dynamic> deleteAccount() {
    return _networkService.delete(
      ApiEndpoints.webstore.profile.profile,
    );
  }
}
