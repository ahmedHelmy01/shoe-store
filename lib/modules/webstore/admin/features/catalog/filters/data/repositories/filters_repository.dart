import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/data/models/filter_row.dart';

abstract class IFiltersRepository {
  Future<ApiResult<AdminPagedResponse<FilterRow>>> getFilters({
    int page = 1,
    String? search,
  });

  Future<ApiResult<FilterRow>> saveFilter(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteFilter(int id);
}

class FiltersRepository extends AdminBaseRepository implements IFiltersRepository {
  final WebStoreAdminRemoteDataSource _ds;

  FiltersRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<FilterRow>>> getFilters({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getFilters(page: page, search: search);
      return parsePaged(json, page, (j) => FilterRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<FilterRow>> saveFilter(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.filters, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.filters, id),
              data,
            );
      return parseSingle(json, (j) => FilterRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteFilter(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.filters, id),
      );
    });
  }
}
