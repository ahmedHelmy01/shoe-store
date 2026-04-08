/// Home Feature State Classes
///
/// Contains all state models for the Home feature.
/// Separated from view models for clean architecture.
library;

import 'package:erp/modules/webstore/home/data/models/webstore_mock_data.dart';

// ─── Home State ──────────────────────────────────────

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

// ─── Location State ─────────────────────────────────

class LocationState {
  final String? selectedBranch;
  LocationState({this.selectedBranch});
}
