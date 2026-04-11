import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/presentation/view_model/admin_products_view_model.dart';
import 'boardings_state.dart';

final boardingsVmProvider = NotifierProvider<BoardingsVm, BoardingsState>(BoardingsVm.new);

class BoardingsVm extends Notifier<BoardingsState> {
  @override
  BoardingsState build() {
    Future.microtask(() => fetch());
    return const BoardingsLoading();
  }

  String _search = '';
  int _page = 1;

  Future<void> fetch({String? search, int? page}) async {
    if (search != null) _search = search;
    if (page != null) _page = page;

    state = const BoardingsLoading();
    final repo = ref.read(webStoreAdminRepositoryProvider);
    final res = await repo.getBoardings(page: _page, search: _search);

    res.when(
      success: (paged) {
        state = BoardingsData(
          items: paged.items,
          page: paged.page,
          lastPage: paged.lastPage,
          total: paged.total,
          search: _search,
        );
      },
      failure: (e) {
        state = BoardingsError(e.message);
      },
    );
  }

  Future<void> refresh() async => fetch(page: _page);

  Future<void> nextPage() async {
    final s = state;
    if (s is! BoardingsData || !s.canNext) return;
    await fetch(page: s.page + 1);
  }

  Future<void> prevPage() async {
    final s = state;
    if (s is! BoardingsData || !s.canPrev) return;
    await fetch(page: s.page - 1);
  }
}
