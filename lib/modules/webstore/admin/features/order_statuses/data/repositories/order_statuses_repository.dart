import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/order_statuses/data/datasource/order_statuses_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/order_statuses/data/models/order_status_row.dart';

abstract class IOrderStatusesRepository {
  Future<ApiResult<AdminPagedResponse<OrderStatusRow>>> getOrderStatuses({
    int page = 1,
    String? search,
  });

  Future<ApiResult<OrderStatusRow>> saveOrderStatus(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteOrderStatus(int id);
}

class OrderStatusesRepository extends AdminBaseRepository implements IOrderStatusesRepository {
  final OrderStatusesRemoteDataSource _ds;

  OrderStatusesRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<OrderStatusRow>>> getOrderStatuses({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getOrderStatuses(page: page, search: search);
      return parsePaged(json, page, (j) => OrderStatusRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<OrderStatusRow>> saveOrderStatus(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.orderStatuses, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.orderStatuses, id),
              data,
            );
      return parseSingle(json, (j) => OrderStatusRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteOrderStatus(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.orderStatuses, id),
      );
    });
  }
}
