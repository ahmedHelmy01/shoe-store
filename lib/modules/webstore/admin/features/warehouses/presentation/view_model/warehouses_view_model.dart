import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/warehouses/data/models/warehouse_row.dart';

final warehousesVmProvider = NotifierProvider<WarehousesVm, AdminCrudState<WarehouseRow>>(WarehousesVm.new);

class WarehousesVm extends AdminCrudVm<WarehouseRow> {
  @override
  Future<ApiResult<AdminPagedResponse<WarehouseRow>>> getItems({required int page, String? search}) {
    return ref.read(webStoreAdminRepositoryProvider).getWarehouses(page: page, search: search);
  }

  @override
  Future<ApiResult<WarehouseRow>> saveItem(Map<String, dynamic> data, {dynamic id}) {
    return ref.read(webStoreAdminRepositoryProvider).saveWarehouse(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(webStoreAdminRepositoryProvider).deleteWarehouse(id as int);
  }
}
