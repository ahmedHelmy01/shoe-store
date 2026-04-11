import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';

sealed class ProductsState {
  const ProductsState();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsError extends ProductsState {
  final String message;
  const ProductsError(this.message);
}

class ProductsData extends ProductsState {
  final List<WebStoreProduct> items;
  final int page;
  final int? lastPage;
  final int? total;
  final String search;

  const ProductsData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
  });

  bool get canPrev => page > 1;
  bool get canNext => lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);
}
