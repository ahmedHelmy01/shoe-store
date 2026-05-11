/// Catalog Feature State Management (Vertical Slices)
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/network/pagination/paginated_response.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/category_model.dart';
import 'package:erp/modules/webstore/catalog/data/repositories/catalog_repository.dart';
import 'package:erp/modules/webstore/catalog/data/datasource/webstore_catalog_remote_datasource.dart';
import 'package:erp/core/providers/core_providers.dart';

// ═══════════════════════════════════════════════════════════════
// 📦 DATA PROVIDERS
// ═══════════════════════════════════════════════════════════════

final catalogRemoteDataSourceProvider = Provider<WebStoreCatalogRemoteDataSource>((ref) {
  return WebStoreCatalogRemoteDataSource(ref.watch(networkServiceProvider));
});

final catalogRepositoryProvider = Provider<ICatalogRepository>((ref) {
  return CatalogRepository(ref.watch(catalogRemoteDataSourceProvider));
});

// ═══════════════════════════════════════════════════════════════
// 📦 STATE MODELS
// ═══════════════════════════════════════════════════════════════

class CategoriesState {
  final List<WebStoreCategory> items;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final PaginationMeta? meta;
  final int? selectedCategoryId;

  const CategoriesState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.meta,
    this.selectedCategoryId,
  });

  bool get hasMore => meta != null && meta!.currentPage < meta!.lastPage;

  CategoriesState copyWith({
    List<WebStoreCategory>? items,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    PaginationMeta? meta,
    int? selectedCategoryId,
  }) {
    return CategoriesState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
      meta: meta ?? this.meta,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

class ProductsState {
  final List<WebStoreProduct> items;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final PaginationMeta? meta;

  const ProductsState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.meta,
  });

  bool get hasMore => meta != null && meta!.currentPage < meta!.lastPage;

  ProductsState copyWith({
    List<WebStoreProduct>? items,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    PaginationMeta? meta,
  }) {
    return ProductsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
      meta: meta ?? this.meta,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 📦 VIEW MODEL / STATE NOTIFIERS
// ═══════════════════════════════════════════════════════════════

/// Paginated list of categories
final catalogCategoriesProvider = NotifierProvider<CategoriesNotifier, CategoriesState>(() {
  return CategoriesNotifier();
});

class CategoriesNotifier extends Notifier<CategoriesState> {
  PaginationParams _params = const PaginationParams(page: 1);

  @override
  CategoriesState build() {
    Future.microtask(() => getCategories());
    return const CategoriesState();
  }

  Future<void> getCategories({bool isRefresh = false}) async {
    if (isRefresh) {
      _params = _params.copyWith(page: 1);
      state = state.copyWith(isLoading: true, items: []);
    } else if (state.items.isEmpty) {
      state = state.copyWith(isLoading: true);
    } else if (state.isLoadingMore || !state.hasMore) {
      return;
    } else {
      state = state.copyWith(isLoadingMore: true);
    }

    final repository = ref.read(catalogRepositoryProvider);
    final result = await repository.getCategories(queryParams: _params.toQueryParameters());

    result.when(
      success: (data) {
        final List<dynamic> list = data['data'] ?? [];
        final categories = list.map((e) => WebStoreCategory.fromJson(e)).toList();
        
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          items: isRefresh ? categories : [...state.items, ...categories],
          errorMessage: null,
          selectedCategoryId: state.selectedCategoryId ?? (categories.isNotEmpty ? categories.first.id : null),
        );

        // Auto-select first category if none selected
        if (state.selectedCategoryId != null) {
          ref.read(catalogProductsProvider.notifier).filterByCategory(state.selectedCategoryId);
        }
      },
      failure: (failure) {
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          errorMessage: failure.message,
        );
      },
    );
  }

  void selectCategory(int? categoryId) {
    if (categoryId == null || state.selectedCategoryId == categoryId) return;
    state = state.copyWith(selectedCategoryId: categoryId);
    ref.read(catalogProductsProvider.notifier).filterByCategory(categoryId);
  }
}

/// Paginated list of products
final catalogProductsProvider = NotifierProvider<ProductsNotifier, ProductsState>(() {
  return ProductsNotifier();
});

class ProductsNotifier extends Notifier<ProductsState> {
  PaginationParams _params = const PaginationParams(page: 1);

  @override
  ProductsState build() {
    // Initial fetch is triggered by category selection
    return const ProductsState();
  }

  Future<void> getProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      _params = _params.copyWith(page: 1);
      state = state.copyWith(isLoading: true, items: []);
    } else if (state.items.isEmpty) {
      state = state.copyWith(isLoading: true);
    } else if (state.isLoadingMore || !state.hasMore) {
      return;
    } else {
      state = state.copyWith(isLoadingMore: true);
    }

    final repository = ref.read(catalogRepositoryProvider);
    final result = await repository.getProducts(queryParams: _params.toQueryParameters());

    result.when(
      success: (data) {
        final paginated = PaginatedResponse.fromJson(data, (item) => WebStoreProduct.fromJson(item));
        
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          items: isRefresh ? paginated.data : [...state.items, ...paginated.data],
          meta: paginated.meta,
          errorMessage: null,
        );
        
        _params = _params.copyWith(page: paginated.meta.currentPage + 1);
      },
      failure: (failure) {
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          errorMessage: failure.message,
        );
      },
    );
  }

  void filterByCategory(int? categoryId) {
    final newFilters = Map<String, dynamic>.from(_params.filters ?? {});
    if (categoryId != null) {
      newFilters['category_id'] = categoryId;
    } else {
      newFilters.remove('category_id');
    }
    _params = _params.copyWith(filters: newFilters, page: 1);
    getProducts(isRefresh: true);
  }

  void search(String query) {
    _params = _params.copyWith(search: query, page: 1);
    getProducts(isRefresh: true);
  }
}
