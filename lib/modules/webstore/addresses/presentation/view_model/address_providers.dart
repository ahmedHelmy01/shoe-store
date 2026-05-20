import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/addresses/data/datasource/address_remote_datasource.dart';
import 'package:erp/modules/webstore/addresses/data/repositories/address_repository.dart';
import 'package:erp/modules/webstore/addresses/data/models/address_model.dart';
import 'package:erp/modules/webstore/addresses/data/models/lookup_models.dart';

final addressRemoteDataSourceProvider = Provider<AddressRemoteDataSource>((ref) {
  return AddressRemoteDataSource(ref.watch(networkServiceProvider));
});

final addressRepositoryProvider = Provider<IAddressRepository>((ref) {
  return AddressRepository(ref.watch(addressRemoteDataSourceProvider));
});

// Cache Governorates list
final governoratesProvider = FutureProvider<List<GovernorateModel>>((ref) async {
  final repo = ref.watch(addressRepositoryProvider);
  final result = await repo.getGovernorates();
  return result.when(
    success: (data) => data,
    failure: (fail) => throw fail.message,
  );
});

// Cities for a selected governorate (API requires governorate_id)
final citiesProvider =
    FutureProvider.family<List<CityModel>, int>((ref, governorateId) async {
  final repo = ref.watch(addressRepositoryProvider);
  final result = await repo.getCities(governorateId: governorateId);
  return result.when(
    success: (data) => data,
    failure: (fail) => throw fail.message,
  );
});

// Manage Addresses List State
final addressesProvider = AsyncNotifierProvider<AddressesNotifier, List<AddressModel>>(() {
  return AddressesNotifier();
});

class AddressesNotifier extends AsyncNotifier<List<AddressModel>> {
  @override
  Future<List<AddressModel>> build() async {
    return _fetchAddresses();
  }

  Future<List<AddressModel>> _fetchAddresses() async {
    final repo = ref.read(addressRepositoryProvider);
    final result = await repo.getAddresses();
    return result.when(
      success: (data) => data,
      failure: (fail) => throw fail.message,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchAddresses());
  }

  /// Returns `null` on success, or an error message from the API.
  Future<String?> createAddress(AddressModel address) async {
    final repo = ref.read(addressRepositoryProvider);
    final result = await repo.createAddress(address);
    return result.when(
      success: (newAddr) {
        state.whenData((list) {
          final updatedList = List<AddressModel>.from(list);
          if (newAddr.isDefault) {
            updatedList.replaceRange(
              0,
              updatedList.length,
              updatedList.map((a) => a.isDefault ? _copyWithDefault(a, false) : a),
            );
          }
          updatedList.add(newAddr);
          state = AsyncValue.data(updatedList);
        });
        return null;
      },
      failure: (fail) => fail.displayMessage,
    );
  }

  /// Returns `null` on success, or an error message from the API.
  Future<String?> updateAddress(int id, AddressModel address) async {
    final repo = ref.read(addressRepositoryProvider);
    final result = await repo.updateAddress(id, address);
    return result.when(
      success: (updatedAddr) {
        state.whenData((list) {
          final updatedList = List<AddressModel>.from(list);
          final index = updatedList.indexWhere((element) => element.id == id);
          if (index != -1) {
            if (updatedAddr.isDefault) {
              updatedList.replaceRange(
                0,
                updatedList.length,
                updatedList.map((a) => a.isDefault ? _copyWithDefault(a, false) : a),
              );
            }
            updatedList[index] = updatedAddr;
            state = AsyncValue.data(updatedList);
          }
        });
        return null;
      },
      failure: (fail) => fail.displayMessage,
    );
  }

  /// Returns `null` on success, or an error message from the API.
  Future<String?> deleteAddress(int id) async {
    final repo = ref.read(addressRepositoryProvider);
    final result = await repo.deleteAddress(id);
    return result.when(
      success: (_) {
        state.whenData((list) {
          final updatedList = List<AddressModel>.from(list);
          updatedList.removeWhere((element) => element.id == id);
          state = AsyncValue.data(updatedList);
        });
        return null;
      },
      failure: (fail) => fail.displayMessage,
    );
  }

  Future<String?> toggleDefault(AddressModel address) async {
    if (address.id == null || address.isDefault) return null;
    final updatedAddress = AddressModel(
      id: address.id,
      name: address.name,
      governorateId: address.governorateId,
      cityId: address.cityId,
      governorateName: address.governorateName,
      cityName: address.cityName,
      area: address.area,
      block: address.block,
      street: address.street,
      building: address.building,
      floor: address.floor,
      apartment: address.apartment,
      phone: address.phone,
      notes: address.notes,
      isDefault: true,
    );
    return updateAddress(address.id!, updatedAddress);
  }

  AddressModel _copyWithDefault(AddressModel a, bool isDefault) {
    return AddressModel(
      id: a.id,
      name: a.name,
      governorateId: a.governorateId,
      cityId: a.cityId,
      governorateName: a.governorateName,
      cityName: a.cityName,
      area: a.area,
      block: a.block,
      street: a.street,
      building: a.building,
      floor: a.floor,
      apartment: a.apartment,
      phone: a.phone,
      notes: a.notes,
      isDefault: isDefault,
    );
  }
}
