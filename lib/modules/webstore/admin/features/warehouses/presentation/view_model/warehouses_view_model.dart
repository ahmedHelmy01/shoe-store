import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/warehouses/data/models/warehouse_row.dart';

final warehousesVmProvider = NotifierProvider<WarehousesVm, AdminCrudState<WarehouseRow>>(WarehousesVm.new);

class WarehousesVm extends AdminCrudVm<WarehouseRow> {
  @override
  void openAdd() {
    print('[WAREHOUSE_VM] openAdd before -> isAdding=${state.isAdding}, editingItem=${state.editingItem?.id}');
    super.openAdd();
    print('[WAREHOUSE_VM] openAdd after -> isAdding=${state.isAdding}, editingItem=${state.editingItem?.id}');
  }

  @override
  void closePanel() {
    print('[WAREHOUSE_VM] closePanel before -> isAdding=${state.isAdding}, editingItem=${state.editingItem?.id}');
    super.closePanel();
    print('[WAREHOUSE_VM] closePanel after -> isAdding=${state.isAdding}, editingItem=${state.editingItem?.id}');
  }

  @override
  Future<ApiResult<AdminPagedResponse<WarehouseRow>>> getItems({required int page, String? search, int? perPage}) {
    return ref.read(warehousesRepositoryProvider).getWarehouses(page: page, search: search);
  }

  @override
  Future<ApiResult<WarehouseRow>> saveItem(Map<String, dynamic> data, {dynamic id, XFile? imageFile, Map<String, dynamic>? extraData, void Function(double)? onProgress}) {
    return ref.read(warehousesRepositoryProvider).saveWarehouse(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(warehousesRepositoryProvider).deleteWarehouse(id as int);
  }

  Future<ApiResult<void>> deleteWarehouse(int id) async {
    final res = await deleteItem(id);
    res.when(
      success: (_) => fetch(page: currentPage),
      failure: (_) {},
    );
    return res;
  }

  int get currentPage {
    final s = state;
    if (s is AdminCrudData<WarehouseRow>) return s.page;
    return 1;
  }
}
