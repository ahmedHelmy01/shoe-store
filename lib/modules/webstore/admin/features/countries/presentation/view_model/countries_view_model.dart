import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/countries/data/models/country_row.dart';

final countriesViewModelProvider = NotifierProvider<CountriesViewModel, AdminCrudState<CountryRow>>(CountriesViewModel.new);

class CountriesViewModel extends AdminCrudVm<CountryRow> {
  @override
  Future<ApiResult<AdminPagedResponse<CountryRow>>> getItems({
    required int page,
    String? search,
    int? perPage,
  }) {
    return ref.read(countriesRepositoryProvider).getCountries(
      page: page,
      search: search,
      perPage: perPage,
    );
  }

  @override
  Future<ApiResult<CountryRow>> saveItem(
    Map<String, dynamic> data, {
    dynamic id,
    XFile? imageFile,
    Map<String, dynamic>? extraData,
    void Function(double)? onProgress,
  }) {
    return ref.read(countriesRepositoryProvider).saveCountry(
      data,
      id: id as int?,
    );
  }

  @override
  Future<ApiResult<void>> deleteItem(dynamic id) {
    return ref.read(countriesRepositoryProvider).deleteCountry(id as int);
  }
}
