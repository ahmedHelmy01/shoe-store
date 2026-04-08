sealed class AdminProductsState {
  const AdminProductsState();
}

class AdminProductsLoading extends AdminProductsState {
  const AdminProductsLoading();
}

class AdminProductsError extends AdminProductsState {
  final String message;
  const AdminProductsError(this.message);
}

class AdminProductsData extends AdminProductsState {
  final List<dynamic> items; // keep light; mapped in UI to avoid tight coupling for now
  final int page;
  final int? lastPage;
  final int? total;
  final String search;
  final bool isFake;

  const AdminProductsData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
    required this.isFake,
  });

  bool get canPrev => page > 1;
  bool get canNext => lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);
}

