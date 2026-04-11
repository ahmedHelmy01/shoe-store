import '../data/models/governorate_row.dart';

sealed class GovernoratesState {
  const GovernoratesState();
}

class GovernoratesLoading extends GovernoratesState {
  const GovernoratesLoading();
}

class GovernoratesError extends GovernoratesState {
  final String message;
  const GovernoratesError(this.message);
}

class GovernoratesData extends GovernoratesState {
  final List<GovernorateRow> items;
  final int page;
  final int? lastPage;
  final int? total;
  final String search;

  const GovernoratesData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
  });

  bool get canPrev => page > 1;
  bool get canNext => lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);
}
