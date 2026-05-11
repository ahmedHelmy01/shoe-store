/// Home Feature State Classes
///
/// Contains all state models for the Home feature.
/// Separated from view models for clean architecture.
library;

import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';

// ─── Home State ──────────────────────────────────────

class HomeState {
  final List<WebStoreProduct> products;
  final List<WebStoreProduct> searchProducts;
  final List<WebStoreProduct> filteredProducts;
  final bool isLoading;

  HomeState({
    this.products = const [],
    this.searchProducts = const [],
    this.filteredProducts = const [],
    this.isLoading = false,
  });

  HomeState copyWith({
    List<WebStoreProduct>? products,
    List<WebStoreProduct>? searchProducts,
    List<WebStoreProduct>? filteredProducts,
    bool? isLoading,
  }) {
    return HomeState(
      products: products ?? this.products,
      searchProducts: searchProducts ?? this.searchProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ─── Location State ─────────────────────────────────

class LocationState {
  final String? selectedBranch;
  final double? latitude;
  final double? longitude;

  LocationState({this.selectedBranch, this.latitude, this.longitude});

  LocationState copyWith({
    String? selectedBranch,
    double? latitude,
    double? longitude,
  }) {
    return LocationState(
      selectedBranch: selectedBranch ?? this.selectedBranch,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
