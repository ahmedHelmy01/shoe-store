import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/home/data/models/coupon_model.dart';

class HomeState {
  final List<WebStoreProduct> products;
  final List<WebStoreProduct> searchProducts;
  final List<WebStoreProduct> filteredProducts;
  final List<StoreCouponModel> coupons;
  final bool isLoading;
  final String? errorMessage;

  HomeState({
    this.products = const [],
    this.searchProducts = const [],
    this.filteredProducts = const [],
    this.coupons = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  HomeState copyWith({
    List<WebStoreProduct>? products,
    List<WebStoreProduct>? searchProducts,
    List<WebStoreProduct>? filteredProducts,
    List<StoreCouponModel>? coupons,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      products: products ?? this.products,
      searchProducts: searchProducts ?? this.searchProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      coupons: coupons ?? this.coupons,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

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
