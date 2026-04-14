import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/models/product_row.dart';

final productsVmProvider = NotifierProvider.autoDispose<ProductsVm, AdminCrudState<ProductRow>>(ProductsVm.new);

class ProductsVm extends AdminCrudVm<ProductRow> {
  @override
  Future<ApiResult<AdminPagedResponse<ProductRow>>> getItems({required int page, String? search}) {
    return ref.read(productsRepositoryProvider).getProducts(page: page, search: search);
  }

  @override
  Future<ApiResult<ProductRow>> saveItem(Map<String, dynamic> data, {dynamic id}) {
    return ref.read(productsRepositoryProvider).saveProduct(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(productsRepositoryProvider).deleteProduct(id as int);
  }
}
