import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/presentation/view_model/admin_products_view_model.dart';
import 'ads_state.dart';

final adsVmProvider = NotifierProvider<AdsVm, AdsState>(AdsVm.new);

class AdsVm extends Notifier<AdsState> {
  @override
  AdsState build() {
    Future.microtask(() => fetch());
    return const AdsLoading();
  }

  String _search = '';
  int _page = 1;

  Future<void> fetch({String? search, int? page}) async {
    if (search != null) _search = search;
    if (page != null) _page = page;

    state = const AdsLoading();
    final repo = ref.read(webStoreAdminRepositoryProvider);
    final res = await repo.getAds(page: _page, search: _search);

    res.when(
      success: (paged) {
        state = AdsData(
          items: paged.items,
          page: paged.page,
          lastPage: paged.lastPage,
          total: paged.total,
          search: _search,
        );
      },
      failure: (e) {
        state = AdsError(e.message);
      },
    );
  }

  Future<void> refresh() async => fetch(page: _page);

  Future<void> nextPage() async {
    final s = state;
    if (s is! AdsData || !s.canNext) return;
    await fetch(page: s.page + 1);
  }

  Future<void> prevPage() async {
    final s = state;
    if (s is! AdsData || !s.canPrev) return;
    await fetch(page: s.page - 1);
  }
}
