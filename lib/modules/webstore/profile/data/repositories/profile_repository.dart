import 'package:erp/core/mock/mock_data.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/auth/data/models/webstore_user_model.dart';

abstract class IProfileRepository {
  Future<ApiResult<WebStoreUser>> getProfile();
  Future<ApiResult<WebStoreUser>> updateProfile({
    String? name,
    String? email,
    String? mobile,
    String? password,
    int? branchId,
  });
  Future<ApiResult<void>> deleteAccount();
}

class ProfileRepository extends BaseRepository implements IProfileRepository {
  ProfileRepository();

  @override
  Future<ApiResult<WebStoreUser>> getProfile() {
    return safeApiCall<WebStoreUser>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.mockUser;
    });
  }

  @override
  Future<ApiResult<WebStoreUser>> updateProfile({
    String? name,
    String? email,
    String? mobile,
    String? password,
    int? branchId,
  }) {
    return safeApiCall<WebStoreUser>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.mockUser;
    });
  }

  @override
  Future<ApiResult<void>> deleteAccount() {
    return safeApiCall<void>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
    });
  }
}
