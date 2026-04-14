import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/data/models/filter_row.dart';

final filtersVmProvider = NotifierProvider.autoDispose<FiltersVm, AdminCrudState<FilterRow>>(FiltersVm.new);

class FiltersVm extends AdminCrudVm<FilterRow> {
  @override
  Future<ApiResult<AdminPagedResponse<FilterRow>>> getItems({required int page, String? search}) {
    return ref.read(webStoreAdminRepositoryProvider).getFilters(page: page, search: search);
  }

  @override
  Future<ApiResult<FilterRow>> saveItem(Map<String, dynamic> data, {dynamic id}) {
    return ref.read(webStoreAdminRepositoryProvider).saveFilter(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(webStoreAdminRepositoryProvider).deleteFilter(id as int);
  }
}
