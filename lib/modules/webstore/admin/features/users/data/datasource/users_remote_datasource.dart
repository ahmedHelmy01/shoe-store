import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/shared/data/datasource/admin_remote_datasource.dart';

class UsersRemoteDataSource extends AdminRemoteDataSource {
  UsersRemoteDataSource(super.network);

  Future<Map<String, dynamic>> getUsers({
    int page = 1,
    String? search,
    int? perPage,
  }) async {
    final res = await network.get(
      ApiEndpoints.webstore.admin.clients,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (perPage != null) 'perPage': perPage,
      },
    );
    return (res as Map).cast<String, dynamic>();
  }
}
