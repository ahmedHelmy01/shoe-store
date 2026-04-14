import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/sliders/data/models/slider_row.dart';

class SlidersTable extends StatelessWidget {
  final List<SliderRow> items;
  final Function(SliderRow slider) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, SliderRow s)? cardBuilder;

  const SlidersTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<SliderRow>(
      rows: items,
      idOf: (s) => '${s.id}',
      exportBaseName: 'sliders',
      searchHint: 'Search sliders…',
      searchText: (s) => '${s.id} ${s.title}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<SliderRow>(
          title: 'ID',
          sortable: true,
          sortValue: (s) => s.id,
          exportValue: (s) => '${s.id}',
          cell: (_, s) => Text('${s.id}'),
          width: 80,
        ),
        AdminColumn<SliderRow>(
          title: 'Title',
          sortable: true,
          sortValue: (s) => s.title,
          exportValue: (s) => s.title,
          cell: (_, s) => Text(s.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 280,
        ),
        AdminColumn<SliderRow>(
          title: 'Active',
          sortable: true,
          sortValue: (s) => s.isActive ? 1 : 0,
          exportValue: (s) => s.isActive ? 'Active' : 'Inactive',
          cell: (_, s) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: s.isActive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              s.isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                color: s.isActive ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          width: 100,
        ),
        AdminColumn<SliderRow>(
          title: 'Actions',
          cell: (_, s) => AdminTableActionsCell<SliderRow>(
            row: s,
            onEdit: onEdit,
            onDelete: (item) => onDelete(item.id),
          ),
          width: 130,
        ),
      ],
    );
  }
}
