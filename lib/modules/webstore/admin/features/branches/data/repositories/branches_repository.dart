import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/branches/data/datasource/branches_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/branches/data/models/branch_row.dart';

abstract class IBranchesRepository {
  Future<ApiResult<AdminPagedResponse<BranchRow>>> getBranches({
    int page = 1,
    String? search,
    int? perPage,
  });

  Future<ApiResult<BranchRow>> saveBranch(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteBranch(int id);
}

class BranchesRepository extends AdminBaseRepository implements IBranchesRepository {
  final BranchesRemoteDataSource _ds;

  BranchesRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<BranchRow>>> getBranches({
    int page = 1,
    String? search,
    int? perPage,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getBranches(page: page, search: search, perPage: perPage);
      return parsePaged(json, page, (j) => BranchRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<BranchRow>> saveBranch(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.branches, data)
          : await _ds.putData(
              '${ApiEndpoints.webstore.admin.branches}/$id',
              data,
            );
      return parseSingle(json, (j) => BranchRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteBranch(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        '${ApiEndpoints.webstore.admin.branches}/$id',
      );
    });
  }
}
