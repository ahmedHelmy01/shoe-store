/// Catalog Feature State Management (Vertical Slices)
library;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/network/pagination/paginated_response.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/category_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/manufacturer_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/tag_model.dart';
import 'package:erp/modules/webstore/catalog/data/repositories/catalog_repository.dart';
import 'package:erp/modules/webstore/catalog/data/datasource/webstore_catalog_remote_datasource.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_state.dart';

// ═══════════════════════════════════════════════════════════════
// 📦 DATA PROVIDERS
// ═══════════════════════════════════════════════════════════════

final catalogRemoteDataSourceProvider =
    Provider<WebStoreCatalogRemoteDataSource>((ref) {
      return WebStoreCatalogRemoteDataSource(ref.watch(networkServiceProvider));
    });

final catalogRepositoryProvider = Provider<ICatalogRepository>((ref) {
  return CatalogRepository(ref.watch(catalogRemoteDataSourceProvider));
});

final catalogManufacturersProvider = FutureProvider<List<ManufacturerModel>>((
  ref,
) async {
  final repository = ref.watch(catalogRepositoryProvider);
  final result = await repository.getManufacturers();
  return result.when(
    success: (data) {
      final list = (data['data'] as List?) ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(ManufacturerModel.fromJson)
          .toList();
    },
    failure: (_) => <ManufacturerModel>[],
  );
});

final catalogTagsProvider = FutureProvider<List<TagModel>>((ref) async {
  final repository = ref.watch(catalogRepositoryProvider);
  final result = await repository.getTags();
  return result.when(
    success: (data) {
      final list = (data['data'] as List?) ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(TagModel.fromJson)
          .toList();
    },
    failure: (_) => <TagModel>[],
  );
});

// ═══════════════════════════════════════════════════════════════
// 📦 VIEW MODEL / STATE NOTIFIERS
// ═══════════════════════════════════════════════════════════════

/// Paginated list of categories

final catalogCategoriesProvider =
    NotifierProvider<CategoriesNotifier, CategoriesState>(() {
      return CategoriesNotifier();
    });

class CategoriesNotifier extends Notifier<CategoriesState> {
  PaginationParams _params = const PaginationParams(page: 1, perPage: 20);

  /// Page number sent on the next categories API call (1-based). Driven locally
  /// so we never repeat the same `page` when the server omits or misreports meta.
  int _nextCategoriesApiPage = 1;

  @override
  CategoriesState build() {
    // 1. Try to load cached categories synchronously on startup to make UI load instantly!
    List<WebStoreCategory> cachedItems = [];
    int? firstCachedId;
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final cachedData = prefs.getString('webstore_categories_cache');
      if (cachedData != null) {
        final Map<String, dynamic> data = jsonDecode(cachedData);
        final List<dynamic> list = data['data'] ?? [];
        cachedItems = list
            .map(
              (item) => WebStoreCategory.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList();
        if (cachedItems.isNotEmpty) {
          firstCachedId = cachedItems.first.id;
        }
      }
    } catch (e) {
      debugPrint('❌ CategoriesNotifier: Error loading cached categories: $e');
    }

    // 2. Trigger async background fetch to get latest categories
    Future.microtask(() => getCategories());

    return CategoriesState(
      items: cachedItems,
      selectedCategoryId: firstCachedId,
    );
  }

  Future<void> getCategories({bool isRefresh = false}) async {
    final hadItemsPriorToFetch = state.items.isNotEmpty;

    if (isRefresh) {
      _nextCategoriesApiPage = 1;
      _params = _params.copyWith(page: 1);
      state = state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        items: [],
        clearMeta: true,
        errorMessage: null,
      );
    } else if (state.items.isEmpty) {
      state = state.copyWith(isLoading: true);
    } else if (state.isLoadingMore || !state.hasMore) {
      return;
    } else {
      state = state.copyWith(isLoadingMore: true);
    }

    final pageSent = _nextCategoriesApiPage;
    final query = Map<String, dynamic>.from(_params.toQueryParameters());
    query['page'] = pageSent;

    final repository = ref.read(catalogRepositoryProvider);
    final result = await repository.getCategories(queryParams: query);

    result.when(
      success: (data) {
        final isPaginationAppend = hadItemsPriorToFetch && !isRefresh;

        final paginated = PaginatedResponse.fromJson(
          data,
          (item) =>
              WebStoreCategory.fromJson(Map<String, dynamic>.from(item as Map)),
        );

        final chunk = paginated.data;
        final perPage = _params.perPage;
        final serverTotal = paginated.meta.total;

        final mergedItems = isRefresh ? chunk : [...state.items, ...chunk];
        final loadedCount = mergedItems.length;

        final totalKnown = serverTotal > 0 ? serverTotal : null;
        final reachedTotal = totalKnown != null && loadedCount >= totalKnown;

        final bool hasMorePages;
        if (chunk.isEmpty) {
          hasMorePages = false;
        } else if (reachedTotal) {
          hasMorePages = false;
        } else if (chunk.length < perPage) {
          hasMorePages = false;
        } else {
          hasMorePages = true;
        }

        final reportedTotal = totalKnown ?? loadedCount;

        final metaForState = PaginationMeta(
          currentPage: pageSent,
          lastPage: hasMorePages ? pageSent + 1 : pageSent,
          perPage: perPage,
          total: reportedTotal,
        );

        final newSelectedId =
            state.selectedCategoryId ??
            (chunk.isNotEmpty ? chunk.first.id : null);

        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          items: mergedItems,
          meta: metaForState,
          errorMessage: null,
          selectedCategoryId: newSelectedId,
        );

        // Cache the successful result if it is the first page or a refresh
        if (pageSent == 1 || isRefresh) {
          try {
            final prefs = ref.read(sharedPreferencesProvider);
            prefs.setString('webstore_categories_cache', jsonEncode(data));
          } catch (e) {
            debugPrint('❌ CategoriesNotifier: Error caching categories: $e');
          }
        }

        if (hasMorePages) {
          _nextCategoriesApiPage = pageSent + 1;
        }

        if (!isPaginationAppend && newSelectedId != null) {
          ref
              .read(catalogProductsProvider.notifier)
              .filterByCategory(newSelectedId);
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
final catalogProductsProvider =
    NotifierProvider<ProductsNotifier, ProductsState>(() {
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
    final categoryId = _params.filters?['category_id'] as int?;
    final cacheKey = categoryId != null
        ? 'webstore_products_cache_category_$categoryId'
        : 'webstore_products_cache_all';

    if (isRefresh) {
      _params = _params.copyWith(page: 1);

      // Load cached products synchronously for this category to avoid a blank loading screen offline!
      List<WebStoreProduct> cachedItems = [];
      try {
        final prefs = ref.read(sharedPreferencesProvider);
        final cachedData = prefs.getString(cacheKey);
        if (cachedData != null) {
          final Map<String, dynamic> decoded = jsonDecode(cachedData);
          final List<dynamic> list = decoded['data'] ?? [];
          cachedItems = list
              .map(
                (item) => WebStoreProduct.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList();
        }
      } catch (e) {
        debugPrint('❌ ProductsNotifier: Error loading cached products: $e');
      }

      state = state.copyWith(
        isLoading: true,
        items: cachedItems,
        errorMessage: null,
      );
    } else if (state.items.isEmpty) {
      state = state.copyWith(isLoading: true);
    } else if (state.isLoadingMore || !state.hasMore) {
      return;
    } else {
      state = state.copyWith(isLoadingMore: true);
    }

    final repository = ref.read(catalogRepositoryProvider);
    final result = await repository.getProducts(
      queryParams: _params.toQueryParameters(),
    );

    result.when(
      success: (data) {
        final paginated = PaginatedResponse.fromJson(
          data,
          (item) => WebStoreProduct.fromJson(item),
        );

        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          items: isRefresh
              ? paginated.data
              : [...state.items, ...paginated.data],
          meta: paginated.meta,
          errorMessage: null,
        );

        // Cache the refreshed successful first page products
        if (isRefresh) {
          try {
            final prefs = ref.read(sharedPreferencesProvider);
            prefs.setString(cacheKey, jsonEncode(data));
          } catch (e) {
            debugPrint('❌ ProductsNotifier: Error caching products: $e');
          }
        }

        _params = _params.copyWith(page: paginated.meta.currentPage + 1);
      },
      failure: (failure) {
        // If we loaded cached items successfully, do NOT show the fullscreen error widget.
        // Instead, just clear loading state so the cached items remain visible and interactive!
        if (state.items.isNotEmpty) {
          state = state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            errorMessage: null,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            errorMessage: failure.message,
          );
        }
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

  void applyApiFilters({
    int? categoryId,
    int? manufacturerId,
    int? tagId,
    double? priceFrom,
    double? priceTo,
    bool? isAvailable,
    String? sortBy,
    String? sortDir,
  }) {
    final newFilters = <String, dynamic>{};
    if (categoryId != null) newFilters['category_id'] = categoryId;
    if (manufacturerId != null) newFilters['manufacturer_id'] = manufacturerId;
    if (tagId != null) newFilters['tag_id'] = tagId;
    if (priceFrom != null) newFilters['price_from'] = priceFrom;
    if (priceTo != null) newFilters['price_to'] = priceTo;
    if (isAvailable != null) newFilters['is_available'] = isAvailable;
    if (sortBy != null && sortBy.isNotEmpty) newFilters['sort_by'] = sortBy;
    if (sortDir != null && sortDir.isNotEmpty) newFilters['sort_dir'] = sortDir;

    _params = _params.copyWith(filters: newFilters, page: 1);
    getProducts(isRefresh: true);
  }

  void search(String query) {
    final trimmed = query.trim();
    final newFilters = Map<String, dynamic>.from(_params.filters ?? {});

    // When searching, do not constrain results by category.
    // When clearing search, restore currently selected category (if any).
    if (trimmed.isNotEmpty) {
      newFilters.remove('category_id');
    } else {
      final selectedCategoryId = ref
          .read(catalogCategoriesProvider)
          .selectedCategoryId;
      if (selectedCategoryId != null) {
        newFilters['category_id'] = selectedCategoryId;
      } else {
        newFilters.remove('category_id');
      }
    }

    _params = _params.copyWith(filters: newFilters, search: trimmed, page: 1);
    getProducts(isRefresh: true);
  }
}

/// Single Product Details Provider
final productDetailsProvider = FutureProvider.family<WebStoreProduct, int>((
  ref,
  id,
) async {
  final prefs = ref.read(sharedPreferencesProvider);
  final cacheKey = 'webstore_product_details_cache_$id';

  final repository = ref.watch(catalogRepositoryProvider);

  // 1. Try to read from cache first for instant loading
  final cachedData = prefs.getString(cacheKey);
  if (cachedData != null) {
    try {
      final decoded = jsonDecode(cachedData);
      return WebStoreProduct.fromJson(decoded);
    } catch (e) {
      debugPrint('❌ productDetailsProvider: Cache parse error: $e');
    }
  }

  // 2. Fetch from server and cache result
  final result = await repository.getProductDetail(id);

  return result.when(
    success: (data) {
      final productData = data['data'];
      try {
        prefs.setString(cacheKey, jsonEncode(productData));
      } catch (e) {
        debugPrint('❌ productDetailsProvider: Cache save error: $e');
      }
      return WebStoreProduct.fromJson(productData);
    },
    failure: (failure) {
      // If server fails but we have cached version, return it instead of throwing!
      if (cachedData != null) {
        try {
          final decoded = jsonDecode(cachedData);
          return WebStoreProduct.fromJson(decoded);
        } catch (e) {
          // Fall through to throw
        }
      }
      throw failure.message;
    },
  );
});

/// Paginated list of products for preset/pushed screens (Auto Disposes when leaving page)
final presetProductsProvider =
    NotifierProvider.autoDispose<PresetProductsNotifier, ProductsState>(() {
      return PresetProductsNotifier();
    });

class PresetProductsNotifier extends Notifier<ProductsState> {
  PaginationParams _params = const PaginationParams(page: 1);

  @override
  ProductsState build() {
    return const ProductsState();
  }

  Future<void> getProducts({bool isRefresh = false}) async {
    final categoryId = _params.filters?['category_id'] as int?;
    final cacheKey = categoryId != null
        ? 'webstore_products_preset_cache_category_$categoryId'
        : 'webstore_products_preset_cache_all';

    if (isRefresh) {
      _params = _params.copyWith(page: 1);

      // Load cached products synchronously
      List<WebStoreProduct> cachedItems = [];
      try {
        final prefs = ref.read(sharedPreferencesProvider);
        final cachedData = prefs.getString(cacheKey);
        if (cachedData != null) {
          final Map<String, dynamic> decoded = jsonDecode(cachedData);
          final List<dynamic> list = decoded['data'] ?? [];
          cachedItems = list
              .map(
                (item) => WebStoreProduct.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList();
        }
      } catch (e) {
        debugPrint(
          '❌ PresetProductsNotifier: Error loading cached products: $e',
        );
      }

      state = state.copyWith(
        isLoading: true,
        items: cachedItems,
        errorMessage: null,
      );
    } else if (state.items.isEmpty) {
      state = state.copyWith(isLoading: true);
    } else if (state.isLoadingMore || !state.hasMore) {
      return;
    } else {
      state = state.copyWith(isLoadingMore: true);
    }

    final repository = ref.read(catalogRepositoryProvider);
    final result = await repository.getProducts(
      queryParams: _params.toQueryParameters(),
    );

    result.when(
      success: (data) {
        final paginated = PaginatedResponse.fromJson(
          data,
          (item) => WebStoreProduct.fromJson(item),
        );

        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          items: isRefresh
              ? paginated.data
              : [...state.items, ...paginated.data],
          meta: paginated.meta,
          errorMessage: null,
        );

        // Cache the refreshed successful first page products
        if (isRefresh) {
          try {
            final prefs = ref.read(sharedPreferencesProvider);
            prefs.setString(cacheKey, jsonEncode(data));
          } catch (e) {
            debugPrint('❌ PresetProductsNotifier: Error caching products: $e');
          }
        }

        _params = _params.copyWith(page: paginated.meta.currentPage + 1);
      },
      failure: (failure) {
        if (state.items.isNotEmpty) {
          state = state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            errorMessage: null,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            errorMessage: failure.message,
          );
        }
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

  void applyApiFilters({
    int? categoryId,
    int? manufacturerId,
    int? tagId,
    double? priceFrom,
    double? priceTo,
    bool? isAvailable,
    String? sortBy,
    String? sortDir,
  }) {
    final newFilters = <String, dynamic>{};
    if (categoryId != null) newFilters['category_id'] = categoryId;
    if (manufacturerId != null) newFilters['manufacturer_id'] = manufacturerId;
    if (tagId != null) newFilters['tag_id'] = tagId;
    if (priceFrom != null) newFilters['price_from'] = priceFrom;
    if (priceTo != null) newFilters['price_to'] = priceTo;
    if (isAvailable != null) newFilters['is_available'] = isAvailable;
    if (sortBy != null && sortBy.isNotEmpty) newFilters['sort_by'] = sortBy;
    if (sortDir != null && sortDir.isNotEmpty) newFilters['sort_dir'] = sortDir;

    _params = _params.copyWith(filters: newFilters, page: 1);
    getProducts(isRefresh: true);
  }

  void search(String query) {
    final trimmed = query.trim();
    final newFilters = Map<String, dynamic>.from(_params.filters ?? {});

    if (trimmed.isNotEmpty) {
      newFilters.remove('category_id');
    } else {
      final selectedCategoryId = ref
          .read(catalogCategoriesProvider)
          .selectedCategoryId;
      if (selectedCategoryId != null) {
        newFilters['category_id'] = selectedCategoryId;
      } else {
        newFilters.remove('category_id');
      }
    }

    _params = _params.copyWith(filters: newFilters, search: trimmed, page: 1);
    getProducts(isRefresh: true);
  }
}
