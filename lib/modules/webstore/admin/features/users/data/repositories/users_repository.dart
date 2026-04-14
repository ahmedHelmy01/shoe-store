import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/users/data/models/user_row.dart';

abstract class IUsersRepository {
  Future<ApiResult<AdminPagedResponse<UserRow>>> getUsers({
    int page = 1,
    String? search,
  });
}

class UsersRepository extends AdminBaseRepository implements IUsersRepository {
  final WebStoreAdminRemoteDataSource _ds;

  UsersRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<UserRow>>> getUsers({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getClients(page: page, search: search);
      return parsePaged(json, page, (j) => UserRow.fromJson(j));
    });
  }
}
