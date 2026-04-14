import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/ads/data/models/ad_row.dart';

class AdsTable extends StatelessWidget {
  final List<AdRow> items;
  final Function(AdRow ad) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, AdRow ad)? cardBuilder;

  const AdsTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<AdRow>(
      rows: items,
      idOf: (a) => '${a.id}',
      exportBaseName: 'ads',
      searchHint: 'Search advertisements…',
      searchText: (a) => '${a.id} ${a.title} ${a.location ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<AdRow>(
          title: 'ID',
          sortable: true,
          sortValue: (a) => a.id,
          exportValue: (a) => '${a.id}',
          cell: (_, a) => Text('${a.id}'),
          width: 80,
        ),
        AdminColumn<AdRow>(
          title: 'Title',
          sortable: true,
          sortValue: (a) => a.title,
          exportValue: (a) => a.title,
          cell: (_, a) => Text(a.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 260,
        ),
        AdminColumn<AdRow>(
          title: 'Active',
          sortable: true,
          sortValue: (a) => a.isActive ? 1 : 0,
          exportValue: (a) => a.isActive ? 'Active' : 'Inactive',
          cell: (_, a) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: a.isActive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              a.isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                color: a.isActive ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          width: 100,
        ),
        AdminColumn<AdRow>(
          title: 'Actions',
          cell: (_, a) => AdminTableActionsCell<AdRow>(
            row: a,
            onEdit: onEdit,
            onDelete: (item) => onDelete(item.id),
          ),
          width: 130,
        ),
      ],
    );
  }
}
