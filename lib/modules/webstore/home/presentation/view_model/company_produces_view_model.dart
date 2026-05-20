import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/catalog/data/models/manufacturer_model.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';

// ─── Company Produces View Model ────────────────────

class CompanyProducesVm extends Notifier<List<ManufacturerModel>> {
  static const _cacheKey = 'webstore_manufacturers_cache';

  @override
  List<ManufacturerModel> build() {
    // Synchronously load from local storage cache during startup to eliminate empty UI delay
    _loadFromCache();
    Future.microtask(() => getCompanyProduces());
    return state;
  }

  void _loadFromCache() {
    final prefs = ref.read(sharedPreferencesProvider);
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      try {
        final List<dynamic> json = jsonDecode(cachedData);
        state = json.map((j) => ManufacturerModel.fromJson(j)).toList();
      } catch (e) {
        debugPrint('❌ CompanyProducesVm: Error loading cache: $e');
        state = [];
      }
    } else {
      state = [];
    }
  }

  Future<void> getCompanyProduces() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final result = await ref.read(catalogRepositoryProvider).getManufacturers();

    result.when(
      success: (data) {
        final List<dynamic> json = data['data'] is List
            ? data['data']
            : (data is List ? data : []);
        final manufacturers = json.map((j) => ManufacturerModel.fromJson(j)).toList();
        state = manufacturers;
        
        // Cache the successful response
        prefs.setString(_cacheKey, jsonEncode(json));
      },
      failure: (error) {
        debugPrint('❌ CompanyProducesVm: Manufacturers fetch failed: ${error.message}');
        // Keep the cached data if network failed
        if (state.isEmpty) {
          _loadFromCache();
        }
      },
    );
  }
}

final companyProducesVmProvider =
    NotifierProvider<CompanyProducesVm, List<ManufacturerModel>>(
      CompanyProducesVm.new,
    );
