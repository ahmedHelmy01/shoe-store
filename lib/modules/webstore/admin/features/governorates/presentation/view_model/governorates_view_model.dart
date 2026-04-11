import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/presentation/view_model/admin_products_view_model.dart';
import 'governorates_state.dart';

final governoratesVmProvider = NotifierProvider<GovernoratesVm, GovernoratesState>(GovernoratesVm.new);

class GovernoratesVm extends Notifier<GovernoratesState> {
  @override
  GovernoratesState build() {
    Future.microtask(() => fetch());
    return const GovernoratesLoading();
  }

  String _search = '';
  int _page = 1;

  Future<void> fetch({String? search, int? page}) async {
    if (search != null) _search = search;
    if (page != null) _page = page;

    state = const GovernoratesLoading();
    final repo = ref.read(webStoreAdminRepositoryProvider);
    final res = await repo.getGovernorates(page: _page, search: _search);

    res.when(
      success: (paged) {
        state = GovernoratesData(
          items: paged.items,
          page: paged.page,
          lastPage: paged.lastPage,
          total: paged.total,
          search: _search,
        );
      },
      failure: (e) {
        state = GovernoratesError(e.message);
      },
    );
  }

  Future<void> refresh() async => fetch(page: _page);

  Future<void> nextPage() async {
    final s = state;
    if (s is! GovernoratesData || !s.canNext) return;
    await fetch(page: s.page + 1);
  }

  Future<void> prevPage() async {
    final s = state;
    if (s is! GovernoratesData || !s.canPrev) return;
    await fetch(page: s.page - 1);
  }
}
