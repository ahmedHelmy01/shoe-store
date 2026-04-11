import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import '../../data/models/ad_row.dart';

class AdsTable extends StatelessWidget {
  final List<AdRow> items;

  const AdsTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<AdRow>(
      rows: items,
      idOf: (a) => '${a.id}',
      exportBaseName: 'ads',
      searchHint: 'Search ads…',
      searchText: (a) => '${a.id} ${a.title} ${a.titleAr ?? ''} ${a.location ?? ''}',
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
          title: 'Title (AR)',
          sortable: true,
          sortValue: (a) => a.titleAr ?? '',
          exportValue: (a) => a.titleAr ?? '',
          cell: (_, a) => Text(a.titleAr ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 260,
        ),
        AdminColumn<AdRow>(
          title: 'Location',
          sortable: true,
          sortValue: (a) => a.location ?? '',
          exportValue: (a) => a.location ?? '',
          cell: (_, a) => Text(a.location ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 160,
        ),
        AdminColumn<AdRow>(
          title: 'Active',
          sortable: true,
          sortValue: (a) => a.isActive ? 1 : 0,
          exportValue: (a) => a.isActive ? 'Yes' : 'No',
          cell: (_, a) => Text(a.isActive ? 'Yes' : 'No'),
          width: 110,
        ),
      ],
    );
  }
}
