import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/auth/login/data/datasource/auth_remote_datasource.dart';

/// Unified Auth Repository (Vertical Slice)
abstract class IAuthRepository {
  Future<ApiResult<Map<String, dynamic>>> login({
    required String email,
    required String password,
  });

  Future<ApiResult<Map<String, dynamic>>> register({
    required Map<String, dynamic> userData,
  });

  Future<ApiResult<Map<String, dynamic>>> getProfile();

  Future<ApiResult<void>> logout();
}

class AuthRepository extends BaseRepository implements IAuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  @override
  Future<ApiResult<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    return safeApiCall<Map<String, dynamic>>(
      () => _remoteDataSource.login(email: email, password: password),
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> register({
    required Map<String, dynamic> userData,
  }) async {
    return safeApiCall<Map<String, dynamic>>(
      () => _remoteDataSource.register(userData: userData),
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getProfile() async {
    return safeApiCall<Map<String, dynamic>>(
      () => _remoteDataSource.getProfile(),
    );
  }

  @override
  Future<ApiResult<void>> logout() async {
    return safeApiCall<void>(
      () => _remoteDataSource.logout(),
    );
  }
}
