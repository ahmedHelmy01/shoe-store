import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/governorates/data/models/governorate_row.dart';

final governoratesVmProvider = NotifierProvider<GovernoratesVm, AdminCrudState<GovernorateRow>>(GovernoratesVm.new);

class GovernoratesVm extends AdminCrudVm<GovernorateRow> {
  @override
  Future<ApiResult<AdminPagedResponse<GovernorateRow>>> getItems({required int page, String? search, int? perPage}) {
    return ref.read(governoratesRepositoryProvider).getGovernorates(page: page, search: search);
  }

  @override
  Future<ApiResult<GovernorateRow>> saveItem(Map<String, dynamic> data, {dynamic id}) {
    return ref.read(governoratesRepositoryProvider).saveGovernorate(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(governoratesRepositoryProvider).deleteGovernorate(id as int);
  }
}
