import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import '../../data/models/warehouse_row.dart';

class WarehousesTable extends StatelessWidget {
  final List<WarehouseRow> items;

  const WarehousesTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<WarehouseRow>(
      rows: items,
      idOf: (w) => '${w.id}',
      exportBaseName: 'warehouses',
      searchHint: 'Search warehouses…',
      searchText: (w) => '${w.id} ${w.name} ${w.location ?? ''}',
      columns: [
        AdminColumn<WarehouseRow>(
          title: 'ID',
          sortable: true,
          sortValue: (w) => w.id,
          exportValue: (w) => '${w.id}',
          cell: (_, w) => Text('${w.id}'),
          width: 80,
        ),
        AdminColumn<WarehouseRow>(
          title: 'Name',
          sortable: true,
          sortValue: (w) => w.name,
          exportValue: (w) => w.name,
          cell: (_, w) => Text(w.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 260,
        ),
        AdminColumn<WarehouseRow>(
          title: 'Location',
          sortable: true,
          sortValue: (w) => w.location ?? '',
          exportValue: (w) => w.location ?? '',
          cell: (_, w) => Text(w.location ?? '-'),
          width: 200,
        ),
        AdminColumn<WarehouseRow>(
          title: 'Active',
          sortable: true,
          sortValue: (w) => w.isActive ? 1 : 0,
          exportValue: (w) => w.isActive ? 'Yes' : 'No',
          cell: (_, w) => Text(w.isActive ? 'Yes' : 'No'),
          width: 100,
        ),
      ],
    );
  }
}
