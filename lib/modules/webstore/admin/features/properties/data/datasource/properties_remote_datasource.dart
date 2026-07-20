import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/shared/data/datasource/admin_remote_datasource.dart';

class PropertiesRemoteDataSource extends AdminRemoteDataSource {
  PropertiesRemoteDataSource(super.network);

  Future<Map<String, dynamic>> getProperties({
    int page = 1,
    String? search,
    int? perPage,
  }) async {
    final res = await network.get(
      ApiEndpoints.webstore.admin.properties,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        'per_page': ?perPage,
      },
    );
    return (res as Map).cast<String, dynamic>();
  }
}
