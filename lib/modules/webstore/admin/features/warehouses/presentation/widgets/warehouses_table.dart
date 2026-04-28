import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/warehouses/data/models/warehouse_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';

class WarehousesTable extends StatelessWidget {
  final List<WarehouseRow> items;
  final Function(WarehouseRow warehouse) onView;
  final Function(WarehouseRow warehouse) onEdit;
  final Function(WarehouseRow warehouse) onDelete;
  final Widget Function(BuildContext context, WarehouseRow w)? cardBuilder;

  const WarehousesTable({
    super.key,
    required this.items,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<WarehouseRow>(
      rows: items,
      idOf: (w) => '${w.id}',
      exportBaseName: 'warehouses',
      searchHint: 'Search warehouses…',
      searchText: (w) => '${w.id} ${w.name} ${w.location ?? ''}',
      cardBuilder: cardBuilder,
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
          cell: (_, w) => Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          width: 280,
        ),
        AdminColumn<WarehouseRow>(
          title: 'Address',
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
          exportValue: (w) => w.isActive ? 'Active' : 'Inactive',
          cell: (_, w) => AdminStatusBadge(isActive: w.isActive),
          width: 100,
        ),
        AdminColumn<WarehouseRow>(
          title: 'Actions',
          cell: (_, w) => AdminTableActionsCell<WarehouseRow>(
            row: w,
            onView: onView,
            onEdit: onEdit,
            onDelete: onDelete,
            confirmBeforeDelete: false,
          ),
          width: 170,
        ),
      ],
    );
  }
}
