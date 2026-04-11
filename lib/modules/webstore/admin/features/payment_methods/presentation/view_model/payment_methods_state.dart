import '../data/models/payment_method_row.dart';

sealed class PaymentMethodsState {
  const PaymentMethodsState();
}

class PaymentMethodsLoading extends PaymentMethodsState {
  const PaymentMethodsLoading();
}

class PaymentMethodsError extends PaymentMethodsState {
  final String message;
  const PaymentMethodsError(this.message);
}

class PaymentMethodsData extends PaymentMethodsState {
  final List<PaymentMethodRow> items;
  final int page;
  final int? lastPage;
  final int? total;
  final String search;

  const PaymentMethodsData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
  });

  bool get canPrev => page > 1;
  bool get canNext => lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);
}
