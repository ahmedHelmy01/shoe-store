import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/catalog/categories/data/models/category_row.dart';

class CategoriesTable extends StatelessWidget {
  final List<CategoryRow> items;
  final Function(CategoryRow c) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, CategoryRow c)? cardBuilder;

  const CategoriesTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<CategoryRow>(
      rows: items,
      idOf: (c) => '${c.id}',
      exportBaseName: 'categories',
      searchHint: 'Search categories…',
      searchText: (c) => '${c.id} ${c.name}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<CategoryRow>(
          title: 'ID',
          sortable: true,
          sortValue: (c) => c.id,
          exportValue: (c) => '${c.id}',
          cell: (_, c) => Text('${c.id}'),
          width: 80,
        ),
        AdminColumn<CategoryRow>(
          title: 'Name',
          sortable: true,
          sortValue: (c) => c.name,
          exportValue: (c) => c.name,
          cell: (_, c) => Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          width: 250,
        ),
        AdminColumn<CategoryRow>(
          title: 'Parent',
          sortable: true,
          sortValue: (c) => c.parentId ?? 0,
          exportValue: (c) => c.parentId?.toString() ?? '-',
          cell: (_, c) => Text(c.parentId?.toString() ?? '-'),
          width: 100,
        ),
        AdminColumn<CategoryRow>(
          title: 'Products',
          sortable: true,
          sortValue: (c) => c.productsCount,
          exportValue: (c) => '${c.productsCount}',
          cell: (_, c) => Text('${c.productsCount}'),
          width: 100,
        ),
        AdminColumn<CategoryRow>(
          title: 'Status',
          sortable: true,
          sortValue: (c) => c.isActive ? 1 : 0,
          exportValue: (c) => c.isActive ? 'Active' : 'Inactive',
          cell: (_, c) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (c.isActive ? Colors.green : Colors.red).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              c.isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                color: c.isActive ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          width: 100,
        ),
        AdminColumn<CategoryRow>(
          title: 'Actions',
          cell: (_, c) => AdminTableActionsCell<CategoryRow>(
            row: c,
            onEdit: onEdit,
            onDelete: (item) => onDelete(item.id),
          ),
          width: 130,
        ),
      ],
    );
  }
}
