import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/pages/data/models/page_row.dart';

final pagesVmProvider = NotifierProvider<PagesVm, AdminCrudState<PageRow>>(PagesVm.new);

class PagesVm extends AdminCrudVm<PageRow> {
  @override
  Future<ApiResult<AdminPagedResponse<PageRow>>> getItems({required int page, String? search}) {
    return ref.read(webStoreAdminRepositoryProvider).getPages(page: page, search: search);
  }

  @override
  Future<ApiResult<PageRow>> saveItem(Map<String, dynamic> data, {dynamic id}) {
    return ref.read(webStoreAdminRepositoryProvider).savePage(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(webStoreAdminRepositoryProvider).deletePage(id as int);
  }
}
