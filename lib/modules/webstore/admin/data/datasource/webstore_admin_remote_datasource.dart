import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class WebStoreAdminRemoteDataSource {
  final NetworkService _network;

  WebStoreAdminRemoteDataSource(this._network);

  Future<Map<String, dynamic>> getProducts({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.products,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }
}

