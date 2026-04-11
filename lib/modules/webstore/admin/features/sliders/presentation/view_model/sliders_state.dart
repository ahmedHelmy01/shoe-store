import '../data/models/slider_row.dart';

sealed class SlidersState {
  const SlidersState();
}

class SlidersLoading extends SlidersState {
  const SlidersLoading();
}

class SlidersError extends SlidersState {
  final String message;
  const SlidersError(this.message);
}

class SlidersData extends SlidersState {
  final List<SliderRow> items;
  final int page;
  final int? lastPage;
  final int? total;
  final String search;

  const SlidersData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
  });

  bool get canPrev => page > 1;
  bool get canNext => lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);
}
