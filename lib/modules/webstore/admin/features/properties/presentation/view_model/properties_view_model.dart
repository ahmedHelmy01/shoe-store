import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/properties/data/models/property_row.dart';

final propertiesVmProvider = NotifierProvider<PropertiesVm, AdminCrudState<PropertyRow>>(PropertiesVm.new);

class PropertiesVm extends AdminCrudVm<PropertyRow> {
  @override
  Future<ApiResult<AdminPagedResponse<PropertyRow>>> getItems({required int page, String? search, int? perPage}) {
    return ref.read(propertiesRepositoryProvider).getProperties(page: page, search: search);
  }

  @override
  Future<ApiResult<PropertyRow>> saveItem(Map<String, dynamic> data, {dynamic id, XFile? imageFile, Map<String, dynamic>? extraData, void Function(double)? onProgress}) {
    return ref.read(propertiesRepositoryProvider).saveProperty(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(propertiesRepositoryProvider).deleteProperty(id as int);
  }
}
