import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/data/datasource/filters_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/data/models/filter_row.dart';

abstract class IFiltersRepository {
  Future<ApiResult<AdminPagedResponse<FilterRow>>> getFilters({
    int page = 1,
    String? search,
    int? perPage,
  });

  Future<ApiResult<FilterRow>> saveFilter(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteFilter(int id);
}

class FiltersRepository extends AdminBaseRepository implements IFiltersRepository {
  final FiltersRemoteDataSource _ds;

  FiltersRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<FilterRow>>> getFilters({
    int page = 1,
    String? search,
    int? perPage,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getFilters(page: page, search: search, perPage: perPage);
      return parsePaged(json, page, (j) => FilterRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<FilterRow>> saveFilter(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.tags, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.tags, id),
              data,
            );
      return parseSingle(json, (j) => FilterRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteFilter(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.tags, id),
      );
    });
  }
}
