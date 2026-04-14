import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/pages/data/models/page_row.dart';

abstract class IPagesRepository {
  Future<ApiResult<AdminPagedResponse<PageRow>>> getPages({
    int page = 1,
    String? search,
  });

  Future<ApiResult<PageRow>> savePage(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deletePage(int id);
}

class PagesRepository extends AdminBaseRepository implements IPagesRepository {
  final WebStoreAdminRemoteDataSource _ds;

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
  Future<ApiResult<PageRow>> savePage(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.pages, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.pages, id),
              data,
            );
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
