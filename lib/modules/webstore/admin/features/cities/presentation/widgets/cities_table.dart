import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/cities/data/models/city_row.dart';

class CitiesTable extends StatelessWidget {
  final List<CityRow> items;
  final Function(CityRow city) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, CityRow c)? cardBuilder;

  const CitiesTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<CityRow>(
      rows: items,
      idOf: (c) => '${c.id}',
      exportBaseName: 'cities',
      searchHint: 'Search cities…',
      searchText: (c) => '${c.id} ${c.name} ${c.nameAr ?? ''} ${c.governorateName ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<CityRow>(
          title: 'ID',
          sortable: true,
          sortValue: (c) => c.id,
          exportValue: (c) => '${c.id}',
          cell: (_, c) => Text('${c.id}'),
          width: 80,
        ),
        AdminColumn<CityRow>(
          title: 'Name',
          sortable: true,
          sortValue: (c) => c.name,
          exportValue: (c) => c.name,
          cell: (_, c) => Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 220,
        ),
        AdminColumn<CityRow>(
          title: 'Name (AR)',
          sortable: true,
          sortValue: (c) => c.nameAr ?? '',
          exportValue: (c) => c.nameAr ?? '',
          cell: (_, c) => Text(c.nameAr ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 220,
        ),
        AdminColumn<CityRow>(
          title: 'Governorate',
          sortable: true,
          sortValue: (c) => c.governorateName ?? '',
          exportValue: (c) => c.governorateName ?? '',
          cell: (_, c) => Text(c.governorateName ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 200,
        ),
        AdminColumn<CityRow>(
          title: 'Fee',
          sortable: true,
          sortValue: (c) => c.deliveryFee,
          exportValue: (c) => '${c.deliveryFee}',
          cell: (_, c) => Text('${c.deliveryFee}'),
          width: 100,
        ),
        AdminColumn<CityRow>(
          title: 'Actions',
          cell: (_, c) => AdminTableActionsCell<CityRow>(
            row: c,
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
