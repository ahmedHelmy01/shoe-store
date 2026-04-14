import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/pages/data/models/page_row.dart';

class PagesTable extends StatelessWidget {
  final List<PageRow> items;
  final Function(PageRow page) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, PageRow p)? cardBuilder;

  const PagesTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<PageRow>(
      rows: items,
      idOf: (p) => '${p.id}',
      exportBaseName: 'pages',
      searchHint: 'Search pages…',
      searchText: (p) => '${p.id} ${p.title} ${p.slug}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<PageRow>(
          title: 'ID',
          sortable: true,
          sortValue: (p) => p.id,
          exportValue: (p) => '${p.id}',
          cell: (_, p) => Text('${p.id}'),
          width: 80,
        ),
        AdminColumn<PageRow>(
          title: 'Title',
          sortable: true,
          sortValue: (p) => p.title,
          exportValue: (p) => p.title,
          cell: (_, p) => Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 260,
        ),
        AdminColumn<PageRow>(
          title: 'Slug',
          sortable: true,
          sortValue: (p) => p.slug,
          exportValue: (p) => p.slug,
          cell: (_, p) => Text(p.slug),
          width: 200,
        ),
        AdminColumn<PageRow>(
          title: 'Active',
          sortable: true,
          sortValue: (p) => p.isActive ? 1 : 0,
          exportValue: (p) => p.isActive ? 'Yes' : 'No',
          cell: (_, p) => Text(p.isActive ? 'Yes' : 'No'),
          width: 100,
        ),
        AdminColumn<PageRow>(
          title: 'Actions',
          cell: (_, p) => AdminTableActionsCell<PageRow>(
            row: p,
            onEdit: onEdit,
            onDelete: (item) => onDelete(item.id),
          ),
          width: 130,
        ),
      ],
    );
  }
}
