import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/customers/customer_groups/data/models/customer_group_row.dart';

final customerGroupsVmProvider = NotifierProvider.autoDispose<CustomerGroupsVm, AdminCrudState<CustomerGroupRow>>(CustomerGroupsVm.new);

class CustomerGroupsVm extends AdminCrudVm<CustomerGroupRow> {
  @override
  Future<ApiResult<AdminPagedResponse<CustomerGroupRow>>> getItems({required int page, String? search, int? perPage}) {
    return ref.read(customerGroupsRepositoryProvider).getCustomerGroups(page: page, search: search);
  }

  @override
  Future<ApiResult<CustomerGroupRow>> saveItem(Map<String, dynamic> data, {dynamic id, XFile? imageFile, Map<String, dynamic>? extraData, void Function(double)? onProgress}) {
    return ref.read(customerGroupsRepositoryProvider).saveCustomerGroup(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(customerGroupsRepositoryProvider).deleteCustomerGroup(id as int);
  }
}
