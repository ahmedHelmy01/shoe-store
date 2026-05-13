import 'dart:convert';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/home/presentation/state/home_state.dart';
import 'package:erp/modules/webstore/home/presentation/state/slider_state.dart';
import 'package:erp/modules/webstore/shared/data/providers/webstore_providers.dart';
import 'package:erp/modules/webstore/home/data/models/slider_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/manufacturer_model.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/services/location_service.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/ads/ads_view_model.dart';

export 'package:erp/modules/webstore/home/presentation/state/home_state.dart';
export 'package:erp/modules/webstore/branches/presentation/view_model/branch_view_model.dart';
export 'package:erp/modules/webstore/branches/presentation/state/branch_state.dart';

import 'package:erp/modules/webstore/home/data/models/coupon_model.dart';

// ─── Home View Model ────────────────────────────────

class HomeVm extends Notifier<HomeState> {
  @override
  HomeState build() {
    Future.microtask(() => initHome());
    return HomeState();
  }

  /// Initial loading sequence optimized for slow networks
  Future<void> initHome() async {
    // 1. Prioritize Coupons (Smallest but important for user)
    await getCoupons();
    
    // 2. Fetch Latest Products
    await getLatestProducts();
    
    // Note: SliderVm and AdsVm handle their own initialization on build
  }

  Future<void> getCoupons() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final cacheKey = 'webstore_coupons_cache';

    final result = await ref.read(cmsRepositoryProvider).getCoupons();
    result.when(
      success: (coupons) {
        state = state.copyWith(coupons: coupons);
        // Cache the successful result
        final jsonList = coupons.map((c) => c.toJson()).toList();
        prefs.setString(cacheKey, jsonEncode(jsonList));
      },
      failure: (error) {
        debugPrint('❌ HomeVm: Coupons fetch failed: ${error.message}');
        
        // Try to load from cache on failure
        final cachedData = prefs.getString(cacheKey);
        if (cachedData != null) {
          try {
            final List<dynamic> json = jsonDecode(cachedData);
            final cachedCoupons = json.map((j) => StoreCouponModel.fromJson(j)).toList();
            state = state.copyWith(coupons: cachedCoupons);
          } catch (e) {
            debugPrint('Error parsing cached coupons: $e');
          }
        }

        if (error.message.contains('timeout')) {
          Future.delayed(const Duration(seconds: 3), () => getCoupons());
        }
      },
    );
  }

  Future<void> getLatestProducts() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final cacheKey = 'webstore_latest_products_cache';
    
    state = state.copyWith(isLoading: true);

    var result = await ref.read(catalogRepositoryProvider).getProducts();

    if (result.isFailure) {
      await Future.delayed(const Duration(seconds: 1));
      result = await ref.read(catalogRepositoryProvider).getProducts();
    }

    result.when(
      success: (data) {
        final List<dynamic> productsJson = data['data'] ?? [];
        final products = productsJson
            .map((j) => WebStoreProduct.fromJson(j))
            .toList();
        state = state.copyWith(
          products: products, 
          isLoading: false,
          errorMessage: null, // Clear error on success
        );
        
        // Cache the successful result
        prefs.setString(cacheKey, jsonEncode(data));
      },
      failure: (error) {
        debugPrint('❌ HomeVm: Products fetch failed: ${error.message}');
        
        // Try to load from cache on failure
        final cachedData = prefs.getString(cacheKey);
        if (cachedData != null) {
          try {
            final Map<String, dynamic> data = jsonDecode(cachedData);
            final List<dynamic> productsJson = data['data'] ?? [];
            final products = productsJson
                .map((j) => WebStoreProduct.fromJson(j))
                .toList();
            state = state.copyWith(
              products: products, 
              isLoading: false,
              errorMessage: null, // If we have cache, don't show error banner
            );
          } catch (e) {
            debugPrint('Error parsing cached products: $e');
            state = state.copyWith(isLoading: false, errorMessage: error.message);
          }
        } else {
          state = state.copyWith(isLoading: false, errorMessage: error.message);
        }
      },
    );
  }

  Future<void> searchProducts(String keyword) async {
    state = state.copyWith(isLoading: true);
    final result = await ref
        .read(catalogRepositoryProvider)
        .getProducts(queryParams: {'search': keyword});

    result.when(
      success: (data) {
        final List<dynamic> productsJson = data['data'] ?? [];
        final products = productsJson
            .map((j) => WebStoreProduct.fromJson(j))
            .toList();
        state = state.copyWith(searchProducts: products, isLoading: false);
      },
      failure: (error) => state = state.copyWith(isLoading: false),
    );
  }

  Future<void> filterProducts({
    double? priceFrom,
    double? priceTo,
    int? categoryId,
    int? manufacturerId,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await ref
        .read(catalogRepositoryProvider)
        .getProducts(
          queryParams: {
            'price_from': priceFrom,
            'price_to': priceTo,
            'category_id': categoryId,
            'manufacturer_id': manufacturerId,
          },
        );

    result.when(
      success: (data) {
        final List<dynamic> productsJson = data['data'] ?? [];
        final products = productsJson
            .map((j) => WebStoreProduct.fromJson(j))
            .toList();
        state = state.copyWith(filteredProducts: products, isLoading: false);
      },
      failure: (error) => state = state.copyWith(isLoading: false),
    );
  }
}

final homeVmProvider = NotifierProvider<HomeVm, HomeState>(HomeVm.new);

// ─── Slider View Model ──────────────────────────────

class SliderVm extends Notifier<SliderState> {
  @override
  SliderState build() {
    Future.microtask(() => getSliders());
    return SliderInitial();
  }

  Future<void> getSliders() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final cacheKey = 'webstore_sliders_cache';

    state = SliderLoading();

    // Attempt 1
    var result = await ref.read(cmsRepositoryProvider).getSliders();

    // Retry Logic
    if (result.isFailure) {
      await Future.delayed(const Duration(seconds: 1));
      result = await ref.read(cmsRepositoryProvider).getSliders();
    }

    result.when(
      success: (data) {
        final List<dynamic> sliderJson = data['data'] ?? [];
        final sliders = sliderJson.map((j) => SliderModel.fromJson(j)).toList();
        state = SliderSuccess(sliders);
        
        // Cache successful result
        prefs.setString(cacheKey, jsonEncode(data));
      },
      failure: (error) {
        debugPrint('❌ SliderVm: Fetch failed: ${error.message}');
        
        // Try cache
        final cachedData = prefs.getString(cacheKey);
        if (cachedData != null) {
          try {
            final Map<String, dynamic> data = jsonDecode(cachedData);
            final List<dynamic> sliderJson = data['data'] ?? [];
            final sliders = sliderJson.map((j) => SliderModel.fromJson(j)).toList();
            state = SliderSuccess(sliders);
          } catch (e) {
            debugPrint('Error parsing cached sliders: $e');
            state = SliderError(error.message);
          }
        } else {
          state = SliderError(error.message);
        }
      },
    );
  }
}

final sliderVmProvider = NotifierProvider<SliderVm, SliderState>(SliderVm.new);

// ─── Company Produces View Model ────────────────────

class CompanyProducesVm extends Notifier<List<ManufacturerModel>> {
  @override
  List<ManufacturerModel> build() {
    Future.microtask(() => getCompanyProduces());
    return [];
  }

  Future<void> getCompanyProduces() async {
    final result = await ref.read(catalogRepositoryProvider).getManufacturers();

    result.when(
      success: (data) {
        final List<dynamic> json = data['data'] is List
            ? data['data']
            : (data is List ? data : []);
        state = json.map((j) => ManufacturerModel.fromJson(j)).toList();
      },
      failure: (error) => debugPrint('❌ HomeVm: Manufacturers fetch failed'),
    );
  }
}

final companyProducesVmProvider =
    NotifierProvider<CompanyProducesVm, List<ManufacturerModel>>(
      CompanyProducesVm.new,
    );

// ─── Location View Model ────────────────────────────

class LocationVm extends Notifier<LocationState> {
  @override
  LocationState build() {
    _initLocation();
    return LocationState(selectedBranch: 'الفرع الرئيسي');
  }

  Future<void> _initLocation() async {
    final branch = await ref.read(sessionManagerProvider).getBranchName();
    if (branch != null) {
      state = state.copyWith(selectedBranch: branch);
    }
  }

  Future<void> requestLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      state = state.copyWith(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    }
  }

  void updateSelectedBranch(String branch) async {
    state = state.copyWith(selectedBranch: branch);
    await ref.read(sessionManagerProvider).setBranchName(branch);
  }
}

final locationProvider = NotifierProvider<LocationVm, LocationState>(
  LocationVm.new,
);
