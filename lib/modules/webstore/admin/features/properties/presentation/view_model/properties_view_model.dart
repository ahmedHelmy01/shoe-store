import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/presentation/view_model/admin_products_view_model.dart';
import 'properties_state.dart';

final propertiesVmProvider = NotifierProvider<PropertiesVm, PropertiesState>(PropertiesVm.new);

class PropertiesVm extends Notifier<PropertiesState> {
  @override
  PropertiesState build() {
    Future.microtask(() => fetch());
    return const PropertiesLoading();
  }

  String _search = '';
  int _page = 1;

  Future<void> fetch({String? search, int? page}) async {
    if (search != null) _search = search;
    if (page != null) _page = page;

    state = const PropertiesLoading();
    final repo = ref.read(webStoreAdminRepositoryProvider);
    final res = await repo.getProperties(page: _page, search: _search);

    res.when(
      success: (paged) {
        state = PropertiesData(
          items: paged.items,
          page: paged.page,
          lastPage: paged.lastPage,
          total: paged.total,
          search: _search,
        );
      },
      failure: (e) {
        state = PropertiesError(e.message);
      },
    );
  }

  Future<void> refresh() async => fetch(page: _page);

  Future<void> nextPage() async {
    final s = state;
    if (s is! PropertiesData || !s.canNext) return;
    await fetch(page: s.page + 1);
  }

  Future<void> prevPage() async {
    final s = state;
    if (s is! PropertiesData || !s.canPrev) return;
    await fetch(page: s.page - 1);
  }
}
