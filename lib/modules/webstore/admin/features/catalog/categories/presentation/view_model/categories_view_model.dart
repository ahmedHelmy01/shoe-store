import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/catalog/categories/data/models/category_row.dart';

final categoriesVmProvider = NotifierProvider.autoDispose<CategoriesVm, AdminCrudState<CategoryRow>>(CategoriesVm.new);

class CategoriesVm extends AdminCrudVm<CategoryRow> {
  @override
  Future<ApiResult<AdminPagedResponse<CategoryRow>>> getItems({required int page, String? search, int? perPage}) {
    return ref.read(categoriesRepositoryProvider).getCategories(page: page, search: search, perPage: perPage);
  }

  @override
  Future<ApiResult<CategoryRow>> saveItem(Map<String, dynamic> data, {dynamic id}) {
    return ref.read(categoriesRepositoryProvider).saveCategory(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(categoriesRepositoryProvider).deleteCategory(id as int);
  }
}
