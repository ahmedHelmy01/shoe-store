import 'package:image_picker/image_picker.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/pages/data/datasource/pages_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/pages/data/models/page_row.dart';

abstract class IPagesRepository {
  Future<ApiResult<AdminPagedResponse<PageRow>>> getPages({
    int page = 1,
    String? search,
  });

  Future<ApiResult<PageRow>> savePage(Map<String, dynamic> data, {int? id, XFile? imageFile, void Function(double)? onProgress});

  Future<ApiResult<void>> deletePage(int id);
}

class PagesRepository extends AdminBaseRepository implements IPagesRepository {
  final PagesRemoteDataSource _ds;

  PagesRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<PageRow>>> getPages({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getPages(page: page, search: search);
      return parsePaged(json, page, (j) => PageRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<PageRow>> savePage(Map<String, dynamic> data, {int? id, XFile? imageFile, void Function(double)? onProgress}) {
    return safeApiCall(() async {
      final path = id == null
          ? ApiEndpoints.webstore.admin.pages
          : ApiEndpoints.withId(ApiEndpoints.webstore.admin.pages, id);

      final Map<String, dynamic> json;
      if (imageFile != null) {
        final fields = toMultipartFields(data);
        json = id == null
            ? await _ds.postMultipart(path, fields: fields, files: {'image': imageFile}, onProgress: onProgress)
            : await _ds.putMultipart(path, fields: fields, files: {'image': imageFile}, onProgress: onProgress);
      } else {
        json = id == null ? await _ds.postData(path, data) : await _ds.putData(path, data);
      }
      return parseSingle(json, (j) => PageRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deletePage(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.pages, id),
      );
    });
  }
}
