import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/auth/data/models/admin_user.dart';

abstract class IAuthRepository {
  Future<ApiResult<AdminUser>> login(String email, String password);
}

class AuthRepository extends AdminBaseRepository implements IAuthRepository {
  final WebStoreAdminRemoteDataSource _ds;

  AuthRepository(this._ds);

  @override
  Future<ApiResult<AdminUser>> login(String email, String password) {
    return safeApiCall(() => _ds.login(email, password));
  }
}
