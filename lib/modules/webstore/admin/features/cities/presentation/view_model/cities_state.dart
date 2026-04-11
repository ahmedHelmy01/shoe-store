import '../data/models/city_row.dart';

sealed class CitiesState {
  const CitiesState();
}

class CitiesLoading extends CitiesState {
  const CitiesLoading();
}

class CitiesError extends CitiesState {
  final String message;
  const CitiesError(this.message);
}

class CitiesData extends CitiesState {
  final List<CityRow> items;
  final int page;
  final int? lastPage;
  final int? total;
  final String search;

  const CitiesData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
  });

  bool get canPrev => page > 1;
  bool get canNext => lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);
}
