import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/data/models/filter_row.dart';

class FiltersTable extends StatelessWidget {
  final List<FilterRow> items;
  final Function(FilterRow f) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, FilterRow f)? cardBuilder;

  const FiltersTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<FilterRow>(
      rows: items,
      idOf: (f) => '${f.id}',
      exportBaseName: 'filters',
      searchHint: 'Search filters…',
      searchText: (f) => '${f.id} ${f.name}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<FilterRow>(
          title: 'ID',
          sortable: true,
          sortValue: (f) => f.id,
          exportValue: (f) => '${f.id}',
          cell: (_, f) => Text('${f.id}'),
          width: 80,
        ),
        AdminColumn<FilterRow>(
          title: 'Name',
          sortable: true,
          sortValue: (f) => f.name,
          exportValue: (f) => f.name,
          cell: (_, f) => Text(f.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          width: 250,
        ),
        AdminColumn<FilterRow>(
          title: 'Type',
          sortable: true,
          sortValue: (f) => f.type,
          exportValue: (f) => f.type,
          cell: (_, f) => Text(f.type, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
          width: 120,
        ),
        AdminColumn<FilterRow>(
          title: 'Status',
          sortable: true,
          sortValue: (f) => f.isActive ? 1 : 0,
          exportValue: (f) => f.isActive ? 'Active' : 'Inactive',
          cell: (_, f) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (f.isActive ? Colors.green : Colors.red).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              f.isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                color: f.isActive ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          width: 100,
        ),
        AdminColumn<FilterRow>(
          title: 'Actions',
          cell: (_, f) => AdminTableActionsCell<FilterRow>(
            row: f,
            onEdit: onEdit,
            onDelete: (item) => onDelete(item.id),
          ),
          width: 130,
        ),
      ],
    );
  }
}
