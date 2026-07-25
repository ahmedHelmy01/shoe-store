import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/catalog/data/models/manufacturer_model.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';

class CompanyProducesState {
  final List<ManufacturerModel> manufacturers;
  final bool isLoading;
  final String? errorMessage;

  const CompanyProducesState({
    this.manufacturers = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  CompanyProducesState copyWith({
    List<ManufacturerModel>? manufacturers,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CompanyProducesState(
      manufacturers: manufacturers ?? this.manufacturers,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ─── Company Produces View Model ────────────────────

class CompanyProducesVm extends Notifier<CompanyProducesState> {
  static const _cacheKey = 'webstore_manufacturers_cache';

  @override
  CompanyProducesState build() {
    final cachedData = _loadFromCache();
    Future.microtask(() => getCompanyProduces());
    return CompanyProducesState(
      manufacturers: cachedData,
      isLoading: cachedData.isEmpty,
    );
  }

  List<ManufacturerModel> _loadFromCache() {
    final prefs = ref.read(sharedPreferencesProvider);
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      try {
        final List<dynamic> json = jsonDecode(cachedData);
        return json.map((j) => ManufacturerModel.fromJson(j)).toList();
      } catch (e) {
        debugPrint('❌ CompanyProducesVm: Error loading cache: $e');
      }
    }
    return [];
  }

  Future<void> getCompanyProduces() async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (state.manufacturers.isEmpty) {
      state = state.copyWith(isLoading: true);
    }
    
    final result = await ref.read(catalogRepositoryProvider).getManufacturers();

    result.when(
      success: (data) {
        final List<dynamic> json = data['data'] is List
            ? data['data']
            : (data is List ? data : []);
        final manufacturers = json.map((j) => ManufacturerModel.fromJson(j)).toList();
        state = state.copyWith(
          manufacturers: manufacturers,
          isLoading: false,
          errorMessage: null,
        );
        
        // Cache the successful response
        prefs.setString(_cacheKey, jsonEncode(json));
      },
      failure: (error) {
        debugPrint('❌ CompanyProducesVm: Manufacturers fetch failed: ${error.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.message,
        );
      },
    );
  }
}

final companyProducesVmProvider =
    NotifierProvider<CompanyProducesVm, CompanyProducesState>(
      CompanyProducesVm.new,
    );
