/// Auth Remote DataSource
///
/// Handles login, register, logout, and token refresh.
library;

import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class AuthRemoteDataSource {
  final NetworkService _networkService;

  AuthRemoteDataSource(this._networkService);

  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    return _networkService.post(
      ApiEndpoints.auth.login,
      body: {'email': email, 'password': password},
    );
  }

  Future<dynamic> register({
    required Map<String, dynamic> userData,
  }) async {
    return _networkService.post(
      ApiEndpoints.auth.register,
      body: userData,
    );
  }

  Future<dynamic> getProfile() async {
    return _networkService.get(ApiEndpoints.auth.profile);
  }

  Future<dynamic> logout() async {
    return _networkService.post(ApiEndpoints.auth.logout);
  }
}
