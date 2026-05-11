import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/cities/data/models/city_row.dart';

final citiesVmProvider = NotifierProvider<CitiesVm, AdminCrudState<CityRow>>(CitiesVm.new);

class CitiesVm extends AdminCrudVm<CityRow> {
  @override
  Future<ApiResult<AdminPagedResponse<CityRow>>> getItems({required int page, String? search, int? perPage}) {
    return ref.read(citiesRepositoryProvider).getCities(page: page, search: search);
  }

  @override
  Future<ApiResult<CityRow>> saveItem(Map<String, dynamic> data, {dynamic id, XFile? imageFile, Map<String, dynamic>? extraData, void Function(double)? onProgress}) {
    return ref.read(citiesRepositoryProvider).saveCity(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(citiesRepositoryProvider).deleteCity(id as int);
  }
}
