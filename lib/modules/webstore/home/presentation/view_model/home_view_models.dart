import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/home/presentation/state/home_state.dart';
import 'package:erp/modules/webstore/shared/data/providers/webstore_providers.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';
import 'package:erp/modules/webstore/home/data/models/coupon_model.dart';

// ─── Re-exports for backward compatibility ──────────
export 'package:erp/modules/webstore/home/presentation/state/home_state.dart';
export 'package:erp/modules/webstore/home/presentation/view_model/slider_view_model.dart';
export 'package:erp/modules/webstore/home/presentation/view_model/company_produces_view_model.dart';
export 'package:erp/modules/webstore/home/presentation/view_model/offers_view_model.dart';
export 'package:erp/modules/webstore/home/presentation/view_model/location_view_model.dart';
export 'package:erp/modules/webstore/branches/presentation/view_model/branch_view_model.dart';
export 'package:erp/modules/webstore/branches/presentation/state/branch_state.dart';

// ─── Home View Model ────────────────────────────────

class HomeVm extends Notifier<HomeState> {
  @override
  HomeState build() {
    Future.microtask(() => initHome());
    return HomeState();
  }

  /// Initial loading sequence — runs in parallel safely
  Future<void> initHome() async {
    await Future.wait([
      getCoupons(),
      getLatestProducts(),
    ]);
  }

  Future<void> getCoupons() async {
    final prefs = ref.read(sharedPreferencesProvider);
    const cacheKey = 'webstore_coupons_cache';

    final result = await ref.read(cmsRepositoryProvider).getCoupons();
    result.when(
      success: (coupons) {
        state = state.copyWith(coupons: coupons);
        final jsonList = coupons.map((c) => c.toJson()).toList();
        prefs.setString(cacheKey, jsonEncode(jsonList));
      },
      failure: (error) {
        debugPrint('❌ HomeVm: Coupons fetch failed: ${error.message}');
        
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
      },
    );
  }

  Future<void> getLatestProducts() async {
    final prefs = ref.read(sharedPreferencesProvider);
    const cacheKey = 'webstore_latest_products_cache';
    
    state = state.copyWith(isLoading: true);

    final result = await ref.read(catalogRepositoryProvider).getProducts();

    result.when(
      success: (data) {
        final List<dynamic> productsJson = data['data'] ?? [];
        final products = productsJson
            .map((j) => WebStoreProduct.fromJson(j))
            .toList();
        state = state.copyWith(
          products: products, 
          isLoading: false,
          errorMessage: null,
        );
        prefs.setString(cacheKey, jsonEncode(data));
      },
      failure: (error) {
        debugPrint('❌ HomeVm: Products fetch failed: ${error.message}');
        
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
              errorMessage: null,
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
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return;

    // Reset search state & clear old results immediately
    state = state.copyWith(
      isSearchLoading: true,
      isSearchLoadingMore: false,
      searchProducts: [],
      searchKeyword: trimmed,
      searchPage: 1,
      searchHasMore: true,
      errorMessage: null,
    );

    final result = await ref
        .read(catalogRepositoryProvider)
        .getProducts(queryParams: {'search': trimmed, 'page': 1});

    result.when(
      success: (data) {
        final List<dynamic> productsJson = data['data'] ?? [];
        final products = productsJson
            .map((j) => WebStoreProduct.fromJson(j))
            .toList();

        final meta = data['meta'];
        int total = 0;
        int lastPage = 1;
        if (meta is Map) {
          total = meta['total'] as int? ?? 0;
          lastPage = meta['last_page'] as int? ?? 1;
        }

        final bool hasMore = products.isNotEmpty &&
            (total > 0 ? products.length < total : 1 < lastPage);

        state = state.copyWith(
          searchProducts: products,
          isSearchLoading: false,
          searchPage: 2,
          searchHasMore: hasMore,
        );
      },
      failure: (error) => state = state.copyWith(
        isSearchLoading: false,
        errorMessage: error.message,
      ),
    );
  }

  Future<void> loadMoreSearch() async {
    if (state.isSearchLoadingMore ||
        state.isSearchLoading ||
        !state.searchHasMore ||
        state.searchKeyword.isEmpty) {
      return;
    }

    state = state.copyWith(isSearchLoadingMore: true);

    final nextPage = state.searchPage;
    final result = await ref
        .read(catalogRepositoryProvider)
        .getProducts(queryParams: {
      'search': state.searchKeyword,
      'page': nextPage,
    });

    result.when(
      success: (data) {
        final List<dynamic> productsJson = data['data'] ?? [];
        final newProducts = productsJson
            .map((j) => WebStoreProduct.fromJson(j))
            .toList();

        final updatedList = [...state.searchProducts, ...newProducts];

        final meta = data['meta'];
        int total = 0;
        int lastPage = nextPage;
        if (meta is Map) {
          total = meta['total'] as int? ?? 0;
          lastPage = meta['last_page'] as int? ?? nextPage;
        }

        final bool hasMore = newProducts.isNotEmpty &&
            (total > 0 ? updatedList.length < total : nextPage < lastPage);

        state = state.copyWith(
          searchProducts: updatedList,
          isSearchLoadingMore: false,
          searchPage: nextPage + 1,
          searchHasMore: hasMore,
        );
      },
      failure: (error) => state = state.copyWith(isSearchLoadingMore: false),
    );
  }

  Future<void> filterProducts({
    double? priceFrom,
    double? priceTo,
    int? categoryId,
    int? manufacturerId,
  }) async {
    state = state.copyWith(isLoading: true, filteredProducts: []);
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

class HomeScrollNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void setScrolling(bool isScrolling) => state = isScrolling;
}

final homeScrollProvider = NotifierProvider<HomeScrollNotifier, bool>(HomeScrollNotifier.new);
