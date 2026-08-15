import 'package:erp/core/mock/mock_data.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/addresses/data/models/address_model.dart';
import 'package:erp/modules/webstore/addresses/data/models/lookup_models.dart';

abstract class IAddressRepository {
  Future<ApiResult<List<GovernorateModel>>> getGovernorates();
  Future<ApiResult<List<CityModel>>> getCities({required int governorateId});
  Future<ApiResult<List<AddressModel>>> getAddresses();
  Future<ApiResult<AddressModel>> createAddress(AddressModel address);
  Future<ApiResult<AddressModel>> getAddressDetails(int id);
  Future<ApiResult<AddressModel>> updateAddress(int id, AddressModel address);
  Future<ApiResult<void>> deleteAddress(int id);
}

class AddressRepository extends BaseRepository implements IAddressRepository {
  AddressRepository();

  @override
  Future<ApiResult<List<GovernorateModel>>> getGovernorates() {
    return safeApiCall<List<GovernorateModel>>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.mockGovernorates;
    });
  }

  @override
  Future<ApiResult<List<CityModel>>> getCities({required int governorateId}) {
    return safeApiCall<List<CityModel>>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.mockCities
          .where((c) => c.governorateId == governorateId)
          .toList();
    });
  }

  @override
  Future<ApiResult<List<AddressModel>>> getAddresses() {
    return safeApiCall<List<AddressModel>>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.mockAddresses;
    });
  }

  @override
  Future<ApiResult<AddressModel>> createAddress(AddressModel address) {
    return safeApiCall<AddressModel>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return address;
    });
  }

  @override
  Future<ApiResult<AddressModel>> getAddressDetails(int id) {
    return safeApiCall<AddressModel>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.mockAddresses.firstWhere(
        (a) => a.id == id,
        orElse: () => MockData.mockAddresses.first,
      );
    });
  }

  @override
  Future<ApiResult<AddressModel>> updateAddress(int id, AddressModel address) {
    return safeApiCall<AddressModel>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return address;
    });
  }

  @override
  Future<ApiResult<void>> deleteAddress(int id) {
    return safeApiCall<void>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
    });
  }
}
