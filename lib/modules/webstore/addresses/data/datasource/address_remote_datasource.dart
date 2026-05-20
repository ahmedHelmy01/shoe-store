import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/addresses/data/models/address_model.dart';

class AddressRemoteDataSource {
  final NetworkService _networkService;

  AddressRemoteDataSource(this._networkService);

  Future<dynamic> getGovernorates() {
    return _networkService.get(ApiEndpoints.webstore.governorates);
  }

  Future<dynamic> getCities({required int governorateId}) {
    return _networkService.get(
      ApiEndpoints.webstore.cities,
      query: {'governorate_id': governorateId},
    );
  }

  Future<dynamic> getAddresses() {
    return _networkService.get(ApiEndpoints.webstore.profile.addresses);
  }

  Future<dynamic> createAddress(AddressModel address) {
    return _networkService.post(
      ApiEndpoints.webstore.profile.addresses,
      body: address.toJson(),
    );
  }

  Future<dynamic> getAddressDetails(int id) {
    return _networkService.get(
      ApiEndpoints.withId(ApiEndpoints.webstore.profile.addresses, id),
    );
  }

  Future<dynamic> updateAddress(int id, AddressModel address) {
    return _networkService.put(
      ApiEndpoints.withId(ApiEndpoints.webstore.profile.addresses, id),
      body: address.toJson(),
    );
  }

  Future<dynamic> deleteAddress(int id) {
    return _networkService.delete(
      ApiEndpoints.withId(ApiEndpoints.webstore.profile.addresses, id),
    );
  }
}
