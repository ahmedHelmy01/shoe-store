/// Home Feature State Classes
///
/// Contains all state models for the Home feature.
/// Separated from view models for clean architecture.
library;

import 'package:erp/modules/webstore/catalog/data/models/category_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';

// ─── Home State ──────────────────────────────────────

class HomeState {
  final List<WebStoreProduct> products;
  final List<WebStoreProduct> searchProducts;
  final List<WebStoreProduct> filteredProducts;
  final List<WebStoreCategory> categories;
  final bool isLoading;

  HomeState({
    this.products = const [],
    this.searchProducts = const [],
    this.filteredProducts = const [],
    this.categories = const [],
    this.isLoading = false,
  });

  HomeState copyWith({
    List<WebStoreProduct>? products,
    List<WebStoreProduct>? searchProducts,
    List<WebStoreProduct>? filteredProducts,
    List<WebStoreCategory>? categories,
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
