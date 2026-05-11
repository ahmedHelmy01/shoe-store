import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/addresses/data/datasource/addresses_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/addresses/data/models/address_row.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';

abstract class IAddressesRepository {
  Future<ApiResult<AdminPagedResponse<AddressRow>>> getAddresses({
    int? customerId,
    int page = 1,
    String? search,
  });

  Future<ApiResult<AddressRow>> saveAddress(Map<String, dynamic> data, {int? id, int? customerId});

  Future<ApiResult<void>> deleteAddress(int id);
}

class AddressesRepository extends AdminBaseRepository implements IAddressesRepository {
  final AddressesRemoteDataSource _ds;

  AddressesRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<AddressRow>>> getAddresses({
    int? customerId,
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getAddresses(customerId: customerId, page: page, search: search);
      return parsePaged(json, page, (j) => AddressRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AddressRow>> saveAddress(Map<String, dynamic> data, {int? id, int? customerId}) {
    return safeApiCall(() async {
      final String path;
      if (id == null) {
        // POST /api/store/admin/clients/{customer}/addresses
        path = ApiEndpoints.webstore.admin.clientAddresses(customerId!);
      } else {
        // PUT /api/store/admin/addresses/{address}
        path = ApiEndpoints.withId(ApiEndpoints.webstore.admin.addresses, id);
      }

      final json = id == null 
          ? await _ds.postData(path, data) 
          : await _ds.putData(path, data);
          
      return parseSingle(json, (j) => AddressRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteAddress(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.addresses, id),
      );
    });
  }
}
