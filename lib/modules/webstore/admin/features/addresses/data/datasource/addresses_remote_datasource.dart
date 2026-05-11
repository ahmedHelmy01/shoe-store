import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/shared/data/datasource/admin_remote_datasource.dart';

class AddressesRemoteDataSource extends AdminRemoteDataSource {
  AddressesRemoteDataSource(super.network);

  Future<Map<String, dynamic>> getAddresses({
    int? customerId,
    int page = 1,
    String? search,
  }) async {
    final path = customerId != null 
        ? ApiEndpoints.webstore.admin.clientAddresses(customerId)
        : ApiEndpoints.webstore.admin.addresses;
        
    final res = await network.get(
      path,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }
}
