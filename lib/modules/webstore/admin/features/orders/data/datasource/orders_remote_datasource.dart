import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/shared/data/datasource/admin_remote_datasource.dart';

class OrdersRemoteDataSource extends AdminRemoteDataSource {
  OrdersRemoteDataSource(super.network);

  Future<Map<String, dynamic>> getOrders({
    int page = 1,
    String? search,
    int? customerId,
  }) async {
    final res = await network.get(
      ApiEndpoints.webstore.admin.orders,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (customerId != null) 'customer_id': customerId,
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getOrderDetails(int id) async {
    final res = await network.get(
      ApiEndpoints.withId(ApiEndpoints.webstore.admin.orders, id),
    );
    return (res as Map).cast<String, dynamic>();
  }
}
