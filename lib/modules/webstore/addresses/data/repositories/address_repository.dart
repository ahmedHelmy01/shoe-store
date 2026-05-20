import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/addresses/data/datasource/address_remote_datasource.dart';
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
  final AddressRemoteDataSource _dataSource;

  AddressRepository(this._dataSource);

  @override
  Future<ApiResult<List<GovernorateModel>>> getGovernorates() {
    return safeApiCall<List<GovernorateModel>>(() async {
      final response = await _dataSource.getGovernorates();
      final list = (response['data'] as List?) ?? response as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(GovernorateModel.fromJson)
          .toList();
    });
  }

  @override
  Future<ApiResult<List<CityModel>>> getCities({required int governorateId}) {
    return safeApiCall<List<CityModel>>(() async {
      final response = await _dataSource.getCities(governorateId: governorateId);
      final list = (response['data'] as List?) ?? response as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(CityModel.fromJson)
          .toList();
    });
  }

  @override
  Future<ApiResult<List<AddressModel>>> getAddresses() {
    return safeApiCall<List<AddressModel>>(() async {
      final response = await _dataSource.getAddresses();
      final list = (response['data'] as List?) ?? response as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(AddressModel.fromJson)
          .toList();
    });
  }

  @override
  Future<ApiResult<AddressModel>> createAddress(AddressModel address) {
    return safeApiCall<AddressModel>(() async {
      final response = await _dataSource.createAddress(address);
      final data = response['data'] ?? response;
      return AddressModel.fromJson(data as Map<String, dynamic>);
    });
  }

  @override
  Future<ApiResult<AddressModel>> getAddressDetails(int id) {
    return safeApiCall<AddressModel>(() async {
      final response = await _dataSource.getAddressDetails(id);
      final data = response['data'] ?? response;
      return AddressModel.fromJson(data as Map<String, dynamic>);
    });
  }

  @override
  Future<ApiResult<AddressModel>> updateAddress(int id, AddressModel address) {
    return safeApiCall<AddressModel>(() async {
      final response = await _dataSource.updateAddress(id, address);
      final data = response['data'] ?? response;
      return AddressModel.fromJson(data as Map<String, dynamic>);
    });
  }

  @override
  Future<ApiResult<void>> deleteAddress(int id) {
    return safeApiCall<void>(() async {
      await _dataSource.deleteAddress(id);
    });
  }
}
