import 'package:erp/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/addresses/data/models/address_row.dart';
import 'package:erp/modules/webstore/admin/features/addresses/data/repositories/addresses_repository.dart';
import 'package:erp/modules/webstore/admin/features/addresses/data/datasource/addresses_remote_datasource.dart';

final addressesRepositoryProvider = Provider<IAddressesRepository>((ref) {
  final ds = AddressesRemoteDataSource(ref.read(networkServiceProvider));
  return AddressesRepository(ds);
});

// Using a standard Notifier but managing the customerId internally or via extraData
final addressesVmProvider =
    NotifierProvider<AddressesVm, AdminCrudState<AddressRow>>(AddressesVm.new);

class AddressesVm extends AdminCrudVm<AddressRow> {
  int? _customerId;

  void setCustomerId(int id) {
    _customerId = id;
  }

  @override
  Future<ApiResult<AdminPagedResponse<AddressRow>>> getItems({
    required int page,
    String? search,
    int? perPage,
  }) {
    return ref
        .read(addressesRepositoryProvider)
        .getAddresses(customerId: _customerId, page: page, search: search);
  }

  @override
  Future<ApiResult<AddressRow>> saveItem(
    Map<String, dynamic> data, {
    dynamic id,
    Map<String, dynamic>? extraData,
    void Function(double)? onProgress,
    dynamic imageFile,
  }) {
    return ref
        .read(addressesRepositoryProvider)
        .saveAddress(data, id: id as int?, customerId: _customerId);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(addressesRepositoryProvider).deleteAddress(id as int);
  }
}
