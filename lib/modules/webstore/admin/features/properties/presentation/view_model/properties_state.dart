import 'package:erp/modules/webstore/admin/features/properties/data/models/property_row.dart';

sealed class PropertiesState {
  const PropertiesState();
}

class PropertiesLoading extends PropertiesState {
  const PropertiesLoading();
}

class PropertiesError extends PropertiesState {
  final String message;
  const PropertiesError(this.message);
}

class PropertiesData extends PropertiesState {
  final List<PropertyRow> items;
  final int page;
  final int? lastPage;
  final int? total;
  final String search;

  const PropertiesData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
  });

  bool get canPrev => page > 1;
  bool get canNext => lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);
}
