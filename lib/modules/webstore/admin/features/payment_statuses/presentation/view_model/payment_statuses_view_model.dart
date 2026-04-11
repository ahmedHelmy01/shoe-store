import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/presentation/view_model/admin_products_view_model.dart';
import 'payment_statuses_state.dart';

final paymentStatusesVmProvider = NotifierProvider<PaymentStatusesVm, PaymentStatusesState>(PaymentStatusesVm.new);

class PaymentStatusesVm extends Notifier<PaymentStatusesState> {
  @override
  PaymentStatusesState build() {
    Future.microtask(() => fetch());
    return const PaymentStatusesLoading();
  }

  String _search = '';
  int _page = 1;

  Future<void> fetch({String? search, int? page}) async {
    if (search != null) _search = search;
    if (page != null) _page = page;

    state = const PaymentStatusesLoading();
    final repo = ref.read(webStoreAdminRepositoryProvider);
    final res = await repo.getPaymentStatuses(page: _page, search: _search);

    res.when(
      success: (paged) {
        state = PaymentStatusesData(
          items: paged.items,
          page: paged.page,
          lastPage: paged.lastPage,
          total: paged.total,
          search: _search,
        );
      },
      failure: (e) {
        state = PaymentStatusesError(e.message);
      },
    );
  }

  Future<void> refresh() async => fetch(page: _page);

  Future<void> nextPage() async {
    final s = state;
    if (s is! PaymentStatusesData || !s.canNext) return;
    await fetch(page: s.page + 1);
  }

  Future<void> prevPage() async {
    final s = state;
    if (s is! PaymentStatusesData || !s.canPrev) return;
    await fetch(page: s.page - 1);
  }
}
