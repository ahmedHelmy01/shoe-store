import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/presentation/view_model/admin_products_view_model.dart';
import 'pages_state.dart';

final pagesVmProvider = NotifierProvider<PagesVm, PagesState>(PagesVm.new);

class PagesVm extends Notifier<PagesState> {
  @override
  PagesState build() {
    Future.microtask(() => fetch());
    return const PagesLoading();
  }

  String _search = '';
  int _page = 1;

  Future<void> fetch({String? search, int? page}) async {
    if (search != null) _search = search;
    if (page != null) _page = page;

    state = const PagesLoading();
    final repo = ref.read(webStoreAdminRepositoryProvider);
    final res = await repo.getPages(page: _page, search: _search);

    res.when(
      success: (paged) {
        state = PagesData(
          items: paged.items,
          page: paged.page,
          lastPage: paged.lastPage,
          total: paged.total,
          search: _search,
        );
      },
      failure: (e) {
        state = PagesError(e.message);
      },
    );
  }

  Future<void> refresh() async => fetch(page: _page);

  Future<void> nextPage() async {
    final s = state;
    if (s is! PagesData || !s.canNext) return;
    await fetch(page: s.page + 1);
  }

  Future<void> prevPage() async {
    final s = state;
    if (s is! PagesData || !s.canPrev) return;
    await fetch(page: s.page - 1);
  }
}
