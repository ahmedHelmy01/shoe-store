import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/presentation/view_model/admin_products_view_model.dart';
import 'branches_state.dart';

final branchesVmProvider = NotifierProvider<BranchesVm, BranchesState>(BranchesVm.new);

class BranchesVm extends Notifier<BranchesState> {
  @override
  BranchesState build() {
    Future.microtask(() => fetch());
    return const BranchesLoading();
  }

  String _search = '';
  int _page = 1;

  Future<void> fetch({String? search, int? page}) async {
    if (search != null) _search = search;
    if (page != null) _page = page;

    state = const BranchesLoading();
    final repo = ref.read(webStoreAdminRepositoryProvider);
    final res = await repo.getBranches(page: _page, search: _search);

    res.when(
      success: (paged) {
        state = BranchesData(
          items: paged.items,
          page: paged.page,
          lastPage: paged.lastPage,
          total: paged.total,
          search: _search,
        );
      },
      failure: (e) {
        state = BranchesError(e.message);
      },
    );
  }

  Future<void> refresh() async => fetch(page: _page);

  Future<void> nextPage() async {
    final s = state;
    if (s is! BranchesData || !s.canNext) return;
    await fetch(page: s.page + 1);
  }

  Future<void> prevPage() async {
    final s = state;
    if (s is! BranchesData || !s.canPrev) return;
    await fetch(page: s.page - 1);
  }
}
