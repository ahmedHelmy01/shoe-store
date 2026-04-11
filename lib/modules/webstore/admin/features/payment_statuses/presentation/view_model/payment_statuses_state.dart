import '../data/models/payment_status_row.dart';

sealed class PaymentStatusesState {
  const PaymentStatusesState();
}

class PaymentStatusesLoading extends PaymentStatusesState {
  const PaymentStatusesLoading();
}

class PaymentStatusesError extends PaymentStatusesState {
  final String message;
  const PaymentStatusesError(this.message);
}

class PaymentStatusesData extends PaymentStatusesState {
  final List<PaymentStatusRow> items;
  final int page;
  final int? lastPage;
  final int? total;
  final String search;

  const PaymentStatusesData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
  });

  bool get canPrev => page > 1;
  bool get canNext => lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);
}
