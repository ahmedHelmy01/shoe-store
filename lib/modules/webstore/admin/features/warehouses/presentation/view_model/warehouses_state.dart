import 'package:erp/modules/webstore/admin/features/warehouses/data/models/warehouse_row.dart';

sealed class WarehousesState {
  const WarehousesState();
}

class WarehousesLoading extends WarehousesState {
  const WarehousesLoading();
}

class WarehousesError extends WarehousesState {
  final String message;
  const WarehousesError(this.message);
}

class WarehousesData extends WarehousesState {
  final List<WarehouseRow> items;
  final int page;
  final int? lastPage;
  final int? total;
  final String search;

  const WarehousesData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
  });

  bool get canPrev => page > 1;
  bool get canNext => lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);
}
