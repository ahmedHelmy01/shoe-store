import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/presentation/view_model/admin_products_view_model.dart';
import 'warehouses_state.dart';

final warehousesVmProvider = NotifierProvider<WarehousesVm, WarehousesState>(WarehousesVm.new);

class WarehousesVm extends Notifier<WarehousesState> {
  @override
  WarehousesState build() {
    Future.microtask(() => fetch());
    return const WarehousesLoading();
  }

  String _search = '';
  int _page = 1;

  Future<void> fetch({String? search, int? page}) async {
    if (search != null) _search = search;
    if (page != null) _page = page;

    state = const WarehousesLoading();
    final repo = ref.read(webStoreAdminRepositoryProvider);
    final res = await repo.getWarehouses(page: _page, search: _search);

    res.when(
      success: (paged) {
        state = WarehousesData(
          items: paged.items,
          page: paged.page,
          lastPage: paged.lastPage,
          total: paged.total,
          search: _search,
        );
      },
      failure: (e) {
        state = WarehousesError(e.message);
      },
    );
  }

  Future<void> refresh() async => fetch(page: _page);

  Future<void> nextPage() async {
    final s = state;
    if (s is! WarehousesData || !s.canNext) return;
    await fetch(page: s.page + 1);
  }

  Future<void> prevPage() async {
    final s = state;
    if (s is! WarehousesData || !s.canPrev) return;
    await fetch(page: s.page - 1);
  }
}
