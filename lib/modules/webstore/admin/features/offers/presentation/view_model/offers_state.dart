import 'package:erp/modules/webstore/admin/features/offers/data/models/offer_row.dart';

sealed class OffersState {
  const OffersState();
}

class OffersLoading extends OffersState {
  const OffersLoading();
}

class OffersError extends OffersState {
  final String message;
  const OffersError(this.message);
}

class OffersData extends OffersState {
  final List<OfferRow> items;
  final int page;
  final int? lastPage;
  final int? total;
  final String search;

  const OffersData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
  });

  bool get canPrev => page > 1;
  bool get canNext => lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);
}
