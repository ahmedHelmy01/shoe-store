import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/governorates/data/models/governorate_row.dart';

abstract class IGovernoratesRepository {
  Future<ApiResult<AdminPagedResponse<GovernorateRow>>> getGovernorates({
    int page = 1,
    String? search,
  });

  Future<ApiResult<GovernorateRow>> saveGovernorate(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteGovernorate(int id);
}

class GovernoratesRepository extends AdminBaseRepository implements IGovernoratesRepository {
  final WebStoreAdminRemoteDataSource _ds;

  GovernoratesRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<GovernorateRow>>> getGovernorates({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getGovernorates(page: page, search: search);
      return parsePaged(json, page, (j) => GovernorateRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<GovernorateRow>> saveGovernorate(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.governorates, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.governorates, id),
              data,
            );
      return parseSingle(json, (j) => GovernorateRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteGovernorate(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.governorates, id),
      );
    });
  }
}
