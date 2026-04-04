import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/home/data/models/webstore_mock_data.dart';

// ─── Home View Model ────────────────────────────────

class HomeState {
  final List<MockProduct> products;
  final List<MockProduct> searchProducts;
  final List<MockProduct> filteredProducts;
  final List<MockCategory> categories;
  final bool isLoading;

  HomeState({
    this.products = const [],
    this.searchProducts = const [],
    this.filteredProducts = const [],
    this.categories = const [],
    this.isLoading = false,
  });

  HomeState copyWith({
    List<MockProduct>? products,
    List<MockProduct>? searchProducts,
    List<MockProduct>? filteredProducts,
    List<MockCategory>? categories,
    bool? isLoading,
  }) {
    return HomeState(
      products: products ?? this.products,
      searchProducts: searchProducts ?? this.searchProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class HomeVm extends Notifier<HomeState> {
  @override
  HomeState build() {
    // Initial fetch
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
    // Simple mock filter
    state = state.copyWith(filteredProducts: WebStoreMockData.featuredProducts, isLoading: false);
  }
}

final homeVmProvider = NotifierProvider<HomeVm, HomeState>(HomeVm.new);

// ─── Slider View Model ──────────────────────────────

class SliderVm extends Notifier<List<MockBanner>> {
  @override
  List<MockBanner> build() {
    Future.microtask(() => getSliders());
    return [];
  }

  Future<void> getSliders() async {
    await Future.delayed(const Duration(milliseconds: 400));
    state = WebStoreMockData.banners;
  }
}

final sliderVmProvider = NotifierProvider<SliderVm, List<MockBanner>>(SliderVm.new);

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

// ─── Location Provider ─────────────────────────────

class LocationState {
  final String? selectedBranch;
  LocationState({this.selectedBranch});
}

class LocationVm extends Notifier<LocationState> {
  @override
  LocationState build() => LocationState(selectedBranch: 'فرع القاهرة الرئيسي');

  void updateSelectedBranch(String branch) {
    state = LocationState(selectedBranch: branch);
  }
}

final locationProvider = NotifierProvider<LocationVm, LocationState>(LocationVm.new);
