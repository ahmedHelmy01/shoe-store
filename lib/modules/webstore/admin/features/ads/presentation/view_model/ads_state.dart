import '../data/models/ad_row.dart';

sealed class AdsState {
  const AdsState();
}

class AdsLoading extends AdsState {
  const AdsLoading();
}

class AdsError extends AdsState {
  final String message;
  const AdsError(this.message);
}

class AdsData extends AdsState {
  final List<AdRow> items;
  final int page;
  final int? lastPage;
  final int? total;
  final String search;

  const AdsData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
  });

  bool get canPrev => page > 1;
  bool get canNext => lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);
}
