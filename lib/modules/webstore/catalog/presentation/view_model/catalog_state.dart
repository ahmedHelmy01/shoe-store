import 'package:erp/core/network/pagination/paginated_response.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/category_model.dart';

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
