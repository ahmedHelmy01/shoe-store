import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';

abstract class IWebStoreAdminRepository {
  Future<ApiResult<AdminPagedResponse<WebStoreProduct>>> getProducts({
    int page = 1,
    String? search,
  });
}

class WebStoreAdminRepository extends BaseRepository implements IWebStoreAdminRepository {
  final WebStoreAdminRemoteDataSource _ds;

  WebStoreAdminRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<WebStoreProduct>>> getProducts({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getProducts(page: page, search: search);

      // Supports multiple backend shapes:
      // 1) { data: { data: [...], current_page, last_page, total } }
      // 2) { data: [...], meta: { current_page, last_page, total } }
      // 3) { data: [...] }
      final data = json['data'];

      List<dynamic> list;
      int currentPage = page;
      int? lastPage;
      int? total;

      if (data is Map) {
        list = (data['data'] as List? ?? const <dynamic>[]);
        currentPage = (data['current_page'] as int?) ?? page;
        lastPage = data['last_page'] as int?;
        total = data['total'] as int?;
      } else if (data is List) {
        list = data;
        final meta = json['meta'];
        if (meta is Map) {
          currentPage = (meta['current_page'] as int?) ?? page;
          lastPage = meta['last_page'] as int?;
          total = meta['total'] as int?;
        }
      } else {
        list = const <dynamic>[];
      }

      final items = list
          .whereType<Map>()
          .map((e) => WebStoreProduct.fromJson(e.cast<String, dynamic>()))
          .toList(growable: false);

      return AdminPagedResponse<WebStoreProduct>(
        items: items,
        page: currentPage,
        lastPage: lastPage,
        total: total,
      );
    });
  }
}

