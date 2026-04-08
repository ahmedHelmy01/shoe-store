/// Home Feature View Models
///
/// Contains all Riverpod Notifiers and Providers for the Home feature.
/// State classes are in `state/home_state.dart`.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/home/data/models/webstore_mock_data.dart';
import 'package:erp/modules/webstore/home/presentation/state/home_state.dart';
import 'package:erp/modules/webstore/home/presentation/state/slider_state.dart';
import 'package:erp/modules/webstore/shared/data/providers/webstore_providers.dart';
import 'package:erp/modules/webstore/cms/data/models/slider_model.dart';
import 'package:erp/core/services/session_manager.dart';

export 'package:erp/modules/webstore/home/presentation/state/home_state.dart';
export 'package:erp/modules/webstore/cms/presentation/view_model/branch_view_model.dart';
export 'package:erp/modules/webstore/cms/presentation/state/branch_state.dart';

// ─── Home View Model ────────────────────────────────

class HomeVm extends Notifier<HomeState> {
  @override
  HomeState build() {
    Future.microtask(() {
      getLatestProducts();
      getCategories();
    });
    return HomeState();
  }

  Future<void> getLatestProducts() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      products: WebStoreMockData.featuredProducts,
      isLoading: false,
    );
  }

  Future<void> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(categories: WebStoreMockData.categories);
  }

  Future<void> searchProducts(String keyword) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    final results = WebStoreMockData.featuredProducts
        .where((p) => p.name.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
    state = state.copyWith(searchProducts: results, isLoading: false);
  }

  Future<void> filterProducts({
    double? priceFrom,
    double? priceTo,
    int? categoryId,
    int? manufacturerId,
  }) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(filteredProducts: WebStoreMockData.featuredProducts, isLoading: false);
  }
}

final homeVmProvider = NotifierProvider<HomeVm, HomeState>(HomeVm.new);

// ─── Slider View Model ──────────────────────────────

class SliderVm extends Notifier<SliderState> {
  @override
  SliderState build() {
    return SliderInitial();
  }

  Future<void> getSliders() async {
    state = SliderLoading();
    
    final result = await ref.read(cmsRepositoryProvider).getSliders();
    
    result.when(
      success: (data) {
        final List<dynamic> sliderJson = data['data'] ?? [];
        final sliders = sliderJson.map((j) => SliderModel.fromJson(j)).toList();
        state = SliderSuccess(sliders);
      },
      failure: (error) {
        state = SliderError(error.message);
      },
    );
  }
}

final sliderVmProvider = NotifierProvider<SliderVm, SliderState>(SliderVm.new);

// Ads have been moved to their dedicated domain provider in ads_view_model.dart.

// ─── Company Produces View Model ────────────────────

class CompanyProducesVm extends Notifier<List<MockCompany>> {
  @override
  List<MockCompany> build() {
    Future.microtask(() => getCompanyProduces());
    return [];
  }

  Future<void> getCompanyProduces() async {
    await Future.delayed(const Duration(milliseconds: 700));
    state = WebStoreMockData.companies;
  }
}

final companyProducesVmProvider =
    NotifierProvider<CompanyProducesVm, List<MockCompany>>(CompanyProducesVm.new);

// ─── Location View Model ────────────────────────────

class LocationVm extends Notifier<LocationState> {
  @override
  LocationState build() {
    _initLocation();
    return LocationState(selectedBranch: 'الفرع الرئيسي');
  }

  Future<void> _initLocation() async {
    final branch = await SessionManager.instance.getBranchName();
    if (branch != null) {
      state = LocationState(selectedBranch: branch);
    }
  }

  void updateSelectedBranch(String branch) async {
    state = LocationState(selectedBranch: branch);
    await SessionManager.instance.setBranchName(branch);
  }
}

final locationProvider = NotifierProvider<LocationVm, LocationState>(LocationVm.new);
