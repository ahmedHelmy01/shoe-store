import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/presentation/view_model/admin_products_view_model.dart';
import 'sliders_state.dart';

final slidersVmProvider = NotifierProvider<SlidersVm, SlidersState>(SlidersVm.new);

class SlidersVm extends Notifier<SlidersState> {
  @override
  SlidersState build() {
    Future.microtask(() => fetch());
    return const SlidersLoading();
  }

  String _search = '';
  int _page = 1;

  Future<void> fetch({String? search, int? page}) async {
    if (search != null) _search = search;
    if (page != null) _page = page;

    state = const SlidersLoading();
    final repo = ref.read(webStoreAdminRepositoryProvider);
    final res = await repo.getSliders(page: _page, search: _search);

    res.when(
      success: (paged) {
        state = SlidersData(
          items: paged.items,
          page: paged.page,
          lastPage: paged.lastPage,
          total: paged.total,
          search: _search,
        );
      },
      failure: (e) {
        state = SlidersError(e.message);
      },
    );
  }

  Future<void> refresh() async => fetch(page: _page);

  Future<void> nextPage() async {
    final s = state;
    if (s is! SlidersData || !s.canNext) return;
    await fetch(page: s.page + 1);
  }

  Future<void> prevPage() async {
    final s = state;
    if (s is! SlidersData || !s.canPrev) return;
    await fetch(page: s.page - 1);
  }
}
