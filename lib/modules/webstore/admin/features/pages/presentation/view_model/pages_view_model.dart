import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/pages/data/models/page_row.dart';

final pagesVmProvider = NotifierProvider.autoDispose<PagesVm, AdminCrudState<PageRow>>(PagesVm.new);

class PagesVm extends AdminCrudVm<PageRow> {
  @override
  Future<ApiResult<AdminPagedResponse<PageRow>>> getItems({required int page, String? search, int? perPage}) {
    return ref.read(pagesRepositoryProvider).getPages(page: page, search: search);
  }

  @override
  Future<ApiResult<PageRow>> saveItem(Map<String, dynamic> data, {dynamic id, XFile? imageFile, Map<String, dynamic>? extraData, void Function(double)? onProgress}) {
    return ref.read(pagesRepositoryProvider).savePage(data, id: id as int?, imageFile: imageFile, onProgress: onProgress);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(pagesRepositoryProvider).deletePage(id as int);
  }
}
