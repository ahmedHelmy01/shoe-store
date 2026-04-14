import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/boardings/data/models/boarding_row.dart';

class BoardingsTable extends StatelessWidget {
  final List<BoardingRow> items;
  final Function(BoardingRow boarding) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, BoardingRow b)? cardBuilder;

  const BoardingsTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<BoardingRow>(
      rows: items,
      idOf: (b) => '${b.id}',
      exportBaseName: 'boardings',
      searchHint: 'Search boardings…',
      searchText: (b) => '${b.id} ${b.title} ${b.titleAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<BoardingRow>(
          title: 'ID',
          sortable: true,
          sortValue: (b) => b.id,
          exportValue: (b) => '${b.id}',
          cell: (_, b) => Text('${b.id}'),
          width: 80,
        ),
        AdminColumn<BoardingRow>(
          title: 'Title',
          sortable: true,
          sortValue: (b) => b.title,
          exportValue: (b) => b.title,
          cell: (_, b) => Text(b.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 300,
        ),
        AdminColumn<BoardingRow>(
          title: 'Title (AR)',
          sortable: true,
          sortValue: (b) => b.titleAr ?? '',
          exportValue: (b) => b.titleAr ?? '',
          cell: (_, b) => Text(b.titleAr ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 260,
        ),
        AdminColumn<BoardingRow>(
          title: 'Order',
          sortable: true,
          sortValue: (b) => b.sortOrder,
          exportValue: (b) => '${b.sortOrder}',
          cell: (_, b) => Text('${b.sortOrder}'),
          width: 100,
        ),
      ],
    );
  }
}
