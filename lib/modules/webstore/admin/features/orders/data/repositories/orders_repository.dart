import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/datasource/orders_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';

abstract class IOrdersRepository {
  Future<ApiResult<AdminPagedResponse<OrderRow>>> getOrders({
    int page = 1,
    String? search,
    int? customerId,
  });

  Future<ApiResult<OrderRow>> saveOrder(Map<String, dynamic> data, {int? id});
  
  Future<ApiResult<void>> updateOrderStatus(int id, int statusId, {String? notes});

  Future<ApiResult<void>> deleteOrder(int id);
}

class OrdersRepository extends AdminBaseRepository implements IOrdersRepository {
  final OrdersRemoteDataSource _ds;

  OrdersRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<OrderRow>>> getOrders({
    int page = 1,
    String? search,
    int? customerId,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getOrders(page: page, search: search, customerId: customerId);
      return parsePaged(json, page, (j) => OrderRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<OrderRow>> saveOrder(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final endpoint = id == null
          ? ApiEndpoints.webstore.admin.orders
          : ApiEndpoints.withId(ApiEndpoints.webstore.admin.orders, id);

      final json = id == null
          ? await _ds.postData(endpoint, data)
          : await _ds.putData(endpoint, data);

      return parseSingle(json, (j) => OrderRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> updateOrderStatus(int id, int statusId, {String? notes}) {
    return safeApiCall(() async {
      await _ds.putData(
        ApiEndpoints.webstore.admin.orderStatusUpdate(id),
        {
          'order_status_id': statusId,
          if (notes != null) 'notes': notes,
        },
      );
    });
  }

  @override
  Future<ApiResult<void>> deleteOrder(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.orders, id),
      );
    });
  }
}
