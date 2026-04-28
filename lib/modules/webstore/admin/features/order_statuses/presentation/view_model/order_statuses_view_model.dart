import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/order_statuses/data/models/order_status_row.dart';

final orderStatusesVmProvider = NotifierProvider<OrderStatusesVm, AdminCrudState<OrderStatusRow>>(OrderStatusesVm.new);

class OrderStatusesVm extends AdminCrudVm<OrderStatusRow> {
  @override
  Future<ApiResult<AdminPagedResponse<OrderStatusRow>>> getItems({required int page, String? search, int? perPage}) {
    return ref.read(orderStatusesRepositoryProvider).getOrderStatuses(page: page, search: search);
  }

  @override
  Future<ApiResult<OrderStatusRow>> saveItem(Map<String, dynamic> data, {dynamic id}) {
    return ref.read(orderStatusesRepositoryProvider).saveOrderStatus(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(orderStatusesRepositoryProvider).deleteOrderStatus(id as int);
  }
}
