import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/shared/data/datasource/webstore_remote_datasource.dart';

abstract class IAuthRepository {
  Future<ApiResult<Map<String, dynamic>>> getProfile();
  Future<ApiResult<Map<String, dynamic>>> updateProfile(Map<String, dynamic> data);
  Future<ApiResult<Map<String, dynamic>>> getAddresses();
  Future<ApiResult<Map<String, dynamic>>> createAddress(Map<String, dynamic> data);
  Future<ApiResult<Map<String, dynamic>>> updateAddress(int id, Map<String, dynamic> data);
  Future<ApiResult<Map<String, dynamic>>> deleteAddress(int id);
}

class AuthRepository extends BaseRepository implements IAuthRepository {
  final WebStoreRemoteDataSource _remoteDataSource;
  AuthRepository(this._remoteDataSource);

  @override
  Future<ApiResult<Map<String, dynamic>>> getProfile() => 
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getProfile());

  @override
  Future<ApiResult<Map<String, dynamic>>> updateProfile(Map<String, dynamic> data) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.updateProfile(data));

  @override
  Future<ApiResult<Map<String, dynamic>>> getAddresses() => 
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getAddresses());

  @override
  Future<ApiResult<Map<String, dynamic>>> createAddress(Map<String, dynamic> data) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.createAddress(data));

  @override
  Future<ApiResult<Map<String, dynamic>>> updateAddress(int id, Map<String, dynamic> data) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.updateAddress(id, data));

  @override
  Future<ApiResult<Map<String, dynamic>>> deleteAddress(int id) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.deleteAddress(id));
}
