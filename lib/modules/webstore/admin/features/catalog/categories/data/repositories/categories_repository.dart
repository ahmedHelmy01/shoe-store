import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/catalog/categories/data/datasource/categories_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/catalog/categories/data/models/category_row.dart';

abstract class ICategoriesRepository {
  Future<ApiResult<AdminPagedResponse<CategoryRow>>> getCategories({
    int page = 1,
    String? search,
    int? perPage,
  });

  Future<ApiResult<CategoryRow>> saveCategory(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteCategory(int id);
}

class CategoriesRepository extends AdminBaseRepository implements ICategoriesRepository {
  final CategoriesRemoteDataSource _ds;

  CategoriesRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<CategoryRow>>> getCategories({
    int page = 1,
    String? search,
    int? perPage,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getCategories(page: page, search: search, perPage: perPage);
      return parsePaged(json, page, (j) => CategoryRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<CategoryRow>> saveCategory(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.categories, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.categories, id),
              data,
            );
      return parseSingle(json, (j) => CategoryRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteCategory(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.categories, id),
      );
    });
  }
}
