import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/features/warehouses/data/models/warehouse_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

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
      searchHint: AdminLocalizations.translate(context, 'search warehouses…'),
      searchText: (w) => '${w.id} ${w.name} ${w.location ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<WarehouseRow>(
          title: AdminLocalizations.translate(context, 'id'),
          sortable: true,
          sortValue: (w) => w.id,
          exportValue: (w) => '${w.id}',
          cell: (_, w) => Text('${w.id}'),
          width: 80,
        ),
        AdminColumn<WarehouseRow>(
          title: AdminLocalizations.translate(context, 'name'),
          sortable: true,
          sortValue: (w) => w.name,
          exportValue: (w) => w.name,
          cell: (_, w) => Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          width: 280,
        ),
        AdminColumn<WarehouseRow>(
          title: AdminLocalizations.translate(context, 'address'),
          sortable: true,
          sortValue: (w) => w.location ?? '',
          exportValue: (w) => w.location ?? '',
          cell: (_, w) => Text(w.location ?? '-'),
          width: 200,
        ),
        AdminColumn<WarehouseRow>(
          title: AdminLocalizations.translate(context, 'status'),
          sortable: true,
          sortValue: (w) => w.isActive ? 1 : 0,
          exportValue: (w) => w.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'),
          cell: (_, w) => AdminStatusBadge(isActive: w.isActive),
          width: 100,
        ),
        AdminColumn<WarehouseRow>(
          title: AdminLocalizations.translate(context, 'actions'),
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
