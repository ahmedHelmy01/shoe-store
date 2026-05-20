import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/profile/data/datasource/profile_remote_datasource.dart';
import 'package:erp/modules/webstore/auth/data/models/webstore_user_model.dart';

abstract class IProfileRepository {
  Future<ApiResult<WebStoreUser>> getProfile();
  Future<ApiResult<WebStoreUser>> updateProfile({
    String? name,
    String? email,
    String? mobile,
    String? password,
  });
  Future<ApiResult<void>> deleteAccount();
}

class ProfileRepository extends BaseRepository implements IProfileRepository {
  final ProfileRemoteDataSource _dataSource;

  ProfileRepository(this._dataSource);

  @override
  Future<ApiResult<WebStoreUser>> getProfile() {
    return safeApiCall<WebStoreUser>(() async {
      final response = await _dataSource.getProfile();
      final data = response['data'] ?? response;
      return WebStoreUser.fromJson(data as Map<String, dynamic>);
    });
  }

  @override
  Future<ApiResult<WebStoreUser>> updateProfile({
    String? name,
    String? email,
    String? mobile,
    String? password,
  }) {
    return safeApiCall<WebStoreUser>(() async {
      final response = await _dataSource.updateProfile(
        name: name,
        email: email,
        mobile: mobile,
        password: password,
      );
      final data = response['data'] ?? response;
      return WebStoreUser.fromJson(data as Map<String, dynamic>);
    });
  }

  @override
  Future<ApiResult<void>> deleteAccount() {
    return safeApiCall<void>(() async {
      await _dataSource.deleteAccount();
    });
  }
}
