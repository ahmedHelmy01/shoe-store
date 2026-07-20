import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/shared/data/datasource/admin_remote_datasource.dart';

class CategoriesRemoteDataSource extends AdminRemoteDataSource {
  CategoriesRemoteDataSource(super.network);

  Future<Map<String, dynamic>> getCategories({
    int page = 1,
    String? search,
    int? perPage,
  }) async {
    final res = await network.get(
      ApiEndpoints.webstore.admin.categories,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        'per_page': ?perPage,
      },
    );
    return (res as Map).cast<String, dynamic>();
  }
}
