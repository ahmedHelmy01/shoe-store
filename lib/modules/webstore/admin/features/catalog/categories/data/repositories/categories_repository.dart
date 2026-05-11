import 'package:image_picker/image_picker.dart';
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

  Future<ApiResult<CategoryRow>> saveCategory(Map<String, dynamic> data, {int? id, XFile? imageFile, void Function(double)? onProgress});

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
  Future<ApiResult<CategoryRow>> saveCategory(Map<String, dynamic> data, {int? id, XFile? imageFile, void Function(double)? onProgress}) {
    return safeApiCall(() async {
      final path = id == null
          ? ApiEndpoints.webstore.admin.categories
          : ApiEndpoints.withId(ApiEndpoints.webstore.admin.categories, id);

      final Map<String, dynamic> json;
      if (imageFile != null) {
        final fields = toMultipartFields(data);
        json = id == null
            ? await _ds.postMultipart(path, fields: fields, files: {'image': imageFile}, onProgress: onProgress)
            : await _ds.putMultipart(path, fields: fields, files: {'image': imageFile}, onProgress: onProgress);
      } else {
        json = id == null ? await _ds.postData(path, data) : await _ds.putData(path, data);
      }
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
