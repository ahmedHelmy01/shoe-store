import '../data/models/boarding_row.dart';

sealed class BoardingsState {
  const BoardingsState();
}

class BoardingsLoading extends BoardingsState {
  const BoardingsLoading();
}

class BoardingsError extends BoardingsState {
  final String message;
  const BoardingsError(this.message);
}

class BoardingsData extends BoardingsState {
  final List<BoardingRow> items;
  final int page;
  final int? lastPage;
  final int? total;
  final String search;

  const BoardingsData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
  });

  bool get canPrev => page > 1;
  bool get canNext => lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);
}
