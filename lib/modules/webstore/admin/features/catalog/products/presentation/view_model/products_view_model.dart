import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'products_state.dart';

final productsVmProvider = NotifierProvider<ProductsVm, ProductsState>(ProductsVm.new);

class ProductsVm extends Notifier<ProductsState> {
  @override
  ProductsState build() {
    Future.microtask(() => fetch());
    return const ProductsLoading();
  }

  String _search = '';
  int _page = 1;

  Future<void> fetch({String? search, int? page}) async {
    if (search != null) _search = search;
    if (page != null) _page = page;

    state = const ProductsLoading();
    final repo = ref.read(webStoreAdminRepositoryProvider);
    final res = await repo.getProducts(page: _page, search: _search);

    res.when(
      success: (paged) {
        state = ProductsData(
          items: paged.items,
          page: paged.page,
          lastPage: paged.lastPage,
          total: paged.total,
          search: _search,
        );
      },
      failure: (e) {
        state = ProductsError(e.message);
      },
    );
  }

  Future<void> refresh() async => fetch(page: _page);

  Future<void> nextPage() async {
    final s = state;
    if (s is! ProductsData || !s.canNext) return;
    await fetch(page: s.page + 1);
  }

  Future<void> prevPage() async {
    final s = state;
    if (s is! ProductsData || !s.canPrev) return;
    await fetch(page: s.page - 1);
  }
}
