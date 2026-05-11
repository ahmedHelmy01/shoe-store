import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/models/product_row.dart';

final productsVmProvider = NotifierProvider.autoDispose<ProductsVm, AdminCrudState<ProductRow>>(ProductsVm.new);

class ProductsVm extends AdminCrudVm<ProductRow> {
  @override
  Future<ApiResult<AdminPagedResponse<ProductRow>>> getItems({required int page, String? search, int? perPage}) {
    return ref.read(productsRepositoryProvider).getProducts(page: page, search: search, perPage: perPage);
  }

  @override
  Future<ApiResult<ProductRow>> saveItem(Map<String, dynamic> data, {dynamic id, XFile? imageFile, Map<String, dynamic>? extraData, void Function(double)? onProgress}) {
    final gallery = extraData?['gallery'] as List<XFile>?;
    return ref.read(productsRepositoryProvider).saveProduct(data, id: id as int?, imageFile: imageFile, galleryFiles: gallery, onProgress: onProgress);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(productsRepositoryProvider).deleteProduct(id as int);
  }

  @override
  void openEdit(ProductRow item) async {
    // Show partial data immediately
    state = state.copyWithUi(editingItem: item, isAdding: false);

    // Fetch full data including tags and properties
    final res = await ref.read(productsRepositoryProvider).getProduct(item.id);
    res.when(
      success: (fullItem) {
        // Only update if we are still editing the same item
        if (state.editingItem?.id == item.id) {
          state = state.copyWithUi(editingItem: fullItem);
        }
      },
      failure: (_) {}, // Fallback to partial data
    );
  }
}
