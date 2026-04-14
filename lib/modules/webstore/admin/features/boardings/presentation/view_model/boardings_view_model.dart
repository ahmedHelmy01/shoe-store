import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/boardings/data/models/boarding_row.dart';

final boardingsVmProvider = NotifierProvider<BoardingsVm, AdminCrudState<BoardingRow>>(BoardingsVm.new);

class BoardingsVm extends AdminCrudVm<BoardingRow> {
  @override
  Future<ApiResult<AdminPagedResponse<BoardingRow>>> getItems({required int page, String? search}) {
    return ref.read(webStoreAdminRepositoryProvider).getBoardings(page: page, search: search);
  }

  @override
  Future<ApiResult<BoardingRow>> saveItem(Map<String, dynamic> data, {dynamic id}) {
    return ref.read(webStoreAdminRepositoryProvider).saveBoarding(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(webStoreAdminRepositoryProvider).deleteBoarding(id as int);
  }
}
