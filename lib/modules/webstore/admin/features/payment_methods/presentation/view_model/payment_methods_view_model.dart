import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/presentation/view_model/admin_products_view_model.dart';
import 'payment_methods_state.dart';

final paymentMethodsVmProvider = NotifierProvider<PaymentMethodsVm, PaymentMethodsState>(PaymentMethodsVm.new);

class PaymentMethodsVm extends Notifier<PaymentMethodsState> {
  @override
  PaymentMethodsState build() {
    Future.microtask(() => fetch());
    return const PaymentMethodsLoading();
  }

  String _search = '';
  int _page = 1;

  Future<void> fetch({String? search, int? page}) async {
    if (search != null) _search = search;
    if (page != null) _page = page;

    state = const PaymentMethodsLoading();
    final repo = ref.read(webStoreAdminRepositoryProvider);
    final res = await repo.getPaymentMethods(page: _page, search: _search);

    res.when(
      success: (paged) {
        state = PaymentMethodsData(
          items: paged.items,
          page: paged.page,
          lastPage: paged.lastPage,
          total: paged.total,
          search: _search,
        );
      },
      failure: (e) {
        state = PaymentMethodsError(e.message);
      },
    );
  }

  Future<void> refresh() async => fetch(page: _page);

  Future<void> nextPage() async {
    final s = state;
    if (s is! PaymentMethodsData || !s.canNext) return;
    await fetch(page: s.page + 1);
  }

  Future<void> prevPage() async {
    final s = state;
    if (s is! PaymentMethodsData || !s.canPrev) return;
    await fetch(page: s.page - 1);
  }
}
