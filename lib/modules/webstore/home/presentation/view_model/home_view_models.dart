import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/home/presentation/state/home_state.dart';
import 'package:erp/modules/webstore/home/presentation/state/slider_state.dart';
import 'package:erp/modules/webstore/shared/data/providers/webstore_providers.dart';
import 'package:erp/modules/webstore/home/data/models/slider_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/category_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/manufacturer_model.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/ads/ads_view_model.dart';

export 'package:erp/modules/webstore/home/presentation/state/home_state.dart';
export 'package:erp/modules/webstore/branches/presentation/view_model/branch_view_model.dart';
export 'package:erp/modules/webstore/branches/presentation/state/branch_state.dart';

// ─── Home View Model ────────────────────────────────

class HomeVm extends Notifier<HomeState> {
  @override
  HomeState build() {
    Future.microtask(() {
      getLatestProducts();
      getCategories();
      // Initialize other components
      ref.read(sliderVmProvider.notifier).getSliders();
      ref.read(adsVmProvider.notifier).getAds();
    });
    return HomeState();
  }

  Future<void> getLatestProducts() async {
    state = state.copyWith(isLoading: true);
    
    // Attempt 1
    var result = await ref.read(catalogRepositoryProvider).getProducts();
    
    // Retry Logic
    if (result.isFailure) {
      await Future.delayed(const Duration(seconds: 1));
      result = await ref.read(catalogRepositoryProvider).getProducts();
    }
    
    result.when(
      success: (data) {
        final List<dynamic> productsJson = data['data'] ?? [];
        final products = productsJson.map((j) => WebStoreProduct.fromJson(j)).toList();
        state = state.copyWith(products: products, isLoading: false);
      },
      failure: (error) {
        debugPrint('❌ HomeVm: Products fetch failed: ${error.message}');
        state = state.copyWith(isLoading: false);
      },
    );
  }

  Future<void> getCategories() async {
    // Attempt 1
    var result = await ref.read(catalogRepositoryProvider).getCategories();
    
    // Retry Logic
    if (result.isFailure) {
      await Future.delayed(const Duration(seconds: 1));
      result = await ref.read(catalogRepositoryProvider).getCategories();
    }

    result.when(
      success: (data) {
        final List<dynamic> categoryJson = data['data'] is List ? data['data'] : (data is List ? data : []);
        final categories = categoryJson.map((j) => WebStoreCategory.fromJson(j)).toList();
        state = state.copyWith(categories: categories);
      },
      failure: (error) => debugPrint('❌ HomeVm: Categories fetch failed'),
    );
  }

  Future<void> searchProducts(String keyword) async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(catalogRepositoryProvider).getProducts(queryParams: {'search': keyword});
    
    result.when(
      success: (data) {
        final List<dynamic> productsJson = data['data'] ?? [];
        final products = productsJson.map((j) => WebStoreProduct.fromJson(j)).toList();
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
    final result = await ref.read(catalogRepositoryProvider).getProducts(queryParams: {
      'price_from': priceFrom,
      'price_to': priceTo,
      'category_id': categoryId,
      'manufacturer_id': manufacturerId,
    });
    
    result.when(
      success: (data) {
        final List<dynamic> productsJson = data['data'] ?? [];
        final products = productsJson.map((j) => WebStoreProduct.fromJson(j)).toList();
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
  SliderState build() => SliderInitial();

  Future<void> getSliders() async {
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
      },
      failure: (error) => state = SliderError(error.message),
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
        final List<dynamic> json = data['data'] is List ? data['data'] : (data is List ? data : []);
        state = json.map((j) => ManufacturerModel.fromJson(j)).toList();
      },
      failure: (error) => debugPrint('❌ HomeVm: Manufacturers fetch failed'),
    );
  }
}

final companyProducesVmProvider =
    NotifierProvider<CompanyProducesVm, List<ManufacturerModel>>(CompanyProducesVm.new);

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
      state = LocationState(selectedBranch: branch);
    }
  }

  void updateSelectedBranch(String branch) async {
    state = LocationState(selectedBranch: branch);
    await ref.read(sessionManagerProvider).setBranchName(branch);
  }
}

final locationProvider = NotifierProvider<LocationVm, LocationState>(LocationVm.new);
