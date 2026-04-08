import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/data/repositories/webstore_admin_repository.dart';
import 'package:erp/modules/webstore/admin/presentation/view_model/admin_products_state.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/presentation/models/admin_fake_data.dart';
import 'package:flutter/foundation.dart';

final webStoreAdminRemoteDataSourceProvider = Provider((ref) {
  final network = ref.watch(networkServiceProvider);
  return WebStoreAdminRemoteDataSource(network);
});

final webStoreAdminRepositoryProvider = Provider<IWebStoreAdminRepository>((ref) {
  final ds = ref.watch(webStoreAdminRemoteDataSourceProvider);
  return WebStoreAdminRepository(ds);
});

final adminProductsVmProvider = NotifierProvider<AdminProductsVm, AdminProductsState>(AdminProductsVm.new);

class AdminProductsVm extends Notifier<AdminProductsState> {
  @override
  AdminProductsState build() {
    Future.microtask(() => fetch());
    return const AdminProductsLoading();
  }

  IWebStoreAdminRepository get _repo => ref.read(webStoreAdminRepositoryProvider);

  String _search = '';
  int _page = 1;
  bool _useFake = false;

  Future<void> fetch({String? search, int? page}) async {
    if (search != null) _search = search;
    if (page != null) _page = page;

    if (_useFake) {
      final items = AdminFakeData.products(count: 57);
      state = AdminProductsData(
        items: items,
        page: 1,
        lastPage: 6,
        total: items.length,
        search: _search,
        isFake: true,
      );
      return;
    }

    state = const AdminProductsLoading();
    final res = await _repo.getProducts(page: _page, search: _search);

    res.when(
      success: (paged) {
        state = AdminProductsData(
          items: paged.items,
          page: paged.page,
          lastPage: paged.lastPage,
          total: paged.total,
          search: _search,
          isFake: false,
        );
      },
      failure: (e) {
        // Helpful fallback in debug to let you see UI controls even before admin APIs are ready/authorized.
        if (kDebugMode) {
          _useFake = true;
          final items = AdminFakeData.products(count: 57);
          state = AdminProductsData(
            items: items,
            page: 1,
            lastPage: 6,
            total: items.length,
            search: _search,
            isFake: true,
          );
          return;
        }
        state = AdminProductsError(e.message);
      },
    );
  }

  Future<void> refresh() async => fetch(page: _page);

  void toggleFake(bool v) {
    _useFake = v;
    fetch(page: 1);
  }

  Future<void> nextPage() async {
    final s = state;
    if (s is! AdminProductsData || !s.canNext) return;
    await fetch(page: s.page + 1);
  }

  Future<void> prevPage() async {
    final s = state;
    if (s is! AdminProductsData || !s.canPrev) return;
    await fetch(page: s.page - 1);
  }
}

