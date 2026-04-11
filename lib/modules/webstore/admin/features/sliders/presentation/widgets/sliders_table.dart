import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import '../../data/models/slider_row.dart';

class SlidersTable extends StatelessWidget {
  final List<SliderRow> items;

  const SlidersTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<SliderRow>(
      rows: items,
      idOf: (s) => '${s.id}',
      exportBaseName: 'sliders',
      searchHint: 'Search sliders…',
      searchText: (s) => '${s.id} ${s.title}',
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
          exportValue: (s) => s.isActive ? 'Yes' : 'No',
          cell: (_, s) => Text(s.isActive ? 'Yes' : 'No'),
          width: 100,
        ),
      ],
    );
  }
}
