import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import '../../data/models/user_row.dart';

final usersVmProvider = NotifierProvider.autoDispose<UsersVm, AdminCrudState<UserRow>>(UsersVm.new);

class UsersVm extends AdminCrudVm<UserRow> {
  @override
  Future<ApiResult<AdminPagedResponse<UserRow>>> getItems({required int page, String? search, int? perPage}) {
    return ref.read(usersRepositoryProvider).getUsers(page: page, search: search);
  }

  @override
  Future<ApiResult<UserRow>> saveItem(Map<String, dynamic> data, {dynamic id, XFile? imageFile, Map<String, dynamic>? extraData, void Function(double)? onProgress}) {
    // For now, we don't have a saveClient API in the repo.
    return Future.value(const ApiFailure(ApiException(
      message: 'Not implemented yet',
      statusCode: 501,
    )));
  }

  @override
  Future<ApiResult<void>> deleteItem(dynamic id) {
    return Future.value(const ApiFailure(ApiException(
      message: 'User deletion is restricted',
      statusCode: 403,
    )));
  }
}
