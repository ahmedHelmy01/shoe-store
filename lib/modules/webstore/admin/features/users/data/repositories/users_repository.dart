import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/features/users/data/datasource/users_remote_datasource.dart';
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
  final UsersRemoteDataSource _ds;

  UsersRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<UserRow>>> getUsers({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getUsers(page: page, search: search);
      return parsePaged(json, page, (j) => UserRow.fromJson(j));
    });
  }
}
