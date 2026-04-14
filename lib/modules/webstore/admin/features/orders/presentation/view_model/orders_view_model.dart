import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';

final ordersVmProvider = NotifierProvider<OrdersVm, AdminCrudState<OrderRow>>(OrdersVm.new);

class OrdersVm extends AdminCrudVm<OrderRow> {
  @override
  Future<ApiResult<AdminPagedResponse<OrderRow>>> getItems({required int page, String? search}) {
    return ref.read(ordersRepositoryProvider).getOrders(page: page, search: search);
  }

  @override
  Future<ApiResult<OrderRow>> saveItem(Map<String, dynamic> data, {dynamic id}) {
    return ref.read(ordersRepositoryProvider).saveOrder(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(ordersRepositoryProvider).deleteOrder(id as int);
  }
}
