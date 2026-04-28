import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/governorates/data/models/governorate_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_table_actions_cell.dart';

class GovernoratesTable extends StatelessWidget {
  final List<GovernorateRow> items;
  final Function(GovernorateRow g) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, GovernorateRow g)? cardBuilder;

  const GovernoratesTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<GovernorateRow>(
      rows: items,
      idOf: (g) => '${g.id}',
      exportBaseName: 'governorates',
      searchHint: 'Search governorates…',
      searchText: (g) => '${g.id} ${g.name} ${g.nameAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<GovernorateRow>(
          title: 'ID',
          sortable: true,
          sortValue: (g) => g.id,
          exportValue: (g) => '${g.id}',
          cell: (_, g) => Text('${g.id}'),
          width: 80,
        ),
        AdminColumn<GovernorateRow>(
          title: 'Name',
          sortable: true,
          sortValue: (g) => g.name,
          exportValue: (g) => g.name,
          cell: (_, g) => Text(g.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 260,
        ),
        AdminColumn<GovernorateRow>(
          title: 'Name (AR)',
          sortable: true,
          sortValue: (g) => g.nameAr ?? '',
          exportValue: (g) => g.nameAr ?? '',
          cell: (_, g) => Text(g.nameAr ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 260,
        ),
        AdminColumn<GovernorateRow>(
          title: 'Active',
          sortable: true,
          sortValue: (g) => g.isActive ? 1 : 0,
          exportValue: (g) => g.isActive ? 'Yes' : 'No',
          cell: (_, g) => Text(g.isActive ? 'Yes' : 'No'),
          width: 100,
        ),
        AdminColumn<GovernorateRow>(
          title: 'Actions',
          cell: (_, g) => AdminTableActionsCell<GovernorateRow>(
            row: g,
            onEdit: onEdit,
            onDelete: (item) => onDelete(item.id),
            confirmBeforeDelete: false,
          ),
          width: 130,
        ),
      ],
    );
  }
}
