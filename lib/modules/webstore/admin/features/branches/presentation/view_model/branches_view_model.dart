import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/branches/data/models/branch_row.dart';

final branchesVmProvider = NotifierProvider<BranchesVm, AdminCrudState<BranchRow>>(BranchesVm.new);

class BranchesVm extends AdminCrudVm<BranchRow> {
  @override
  Future<ApiResult<AdminPagedResponse<BranchRow>>> getItems({required int page, String? search, int? perPage}) {
    return ref.read(branchesRepositoryProvider).getBranches(page: page, search: search, perPage: perPage);
  }

  @override
  Future<ApiResult<BranchRow>> saveItem(Map<String, dynamic> data, {dynamic id, XFile? imageFile, Map<String, dynamic>? extraData, void Function(double)? onProgress}) {
    return ref.read(branchesRepositoryProvider).saveBranch(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(branchesRepositoryProvider).deleteBranch(id as int);
  }
}
