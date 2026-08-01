import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/home/data/models/coupon_model.dart';

class HomeState {
  final List<WebStoreProduct> products;
  final List<WebStoreProduct> searchProducts;
  final List<WebStoreProduct> filteredProducts;
  final List<StoreCouponModel> coupons;
  final bool isLoading;
  final bool isSearchLoading;
  final bool isSearchLoadingMore;
  final bool searchHasMore;
  final int searchPage;
  final String searchKeyword;
  final String? errorMessage;

  HomeState({
    this.products = const [],
    this.searchProducts = const [],
    this.filteredProducts = const [],
    this.coupons = const [],
    this.isLoading = false,
    this.isSearchLoading = false,
    this.isSearchLoadingMore = false,
    this.searchHasMore = true,
    this.searchPage = 1,
    this.searchKeyword = '',
    this.errorMessage,
  });

  HomeState copyWith({
    List<WebStoreProduct>? products,
    List<WebStoreProduct>? searchProducts,
    List<WebStoreProduct>? filteredProducts,
    List<StoreCouponModel>? coupons,
    bool? isLoading,
    bool? isSearchLoading,
    bool? isSearchLoadingMore,
    bool? searchHasMore,
    int? searchPage,
    String? searchKeyword,
    String? errorMessage,
  }) {
    return HomeState(
      products: products ?? this.products,
      searchProducts: searchProducts ?? this.searchProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      coupons: coupons ?? this.coupons,
      isLoading: isLoading ?? this.isLoading,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      isSearchLoadingMore: isSearchLoadingMore ?? this.isSearchLoadingMore,
      searchHasMore: searchHasMore ?? this.searchHasMore,
      searchPage: searchPage ?? this.searchPage,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

