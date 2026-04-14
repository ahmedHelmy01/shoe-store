import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/properties/data/models/property_row.dart';

class PropertiesTable extends StatelessWidget {
  final List<PropertyRow> items;
  final Function(PropertyRow property) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, PropertyRow p)? cardBuilder;

  const PropertiesTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<PropertyRow>(
      rows: items,
      idOf: (p) => '${p.id}',
      exportBaseName: 'properties',
      searchHint: 'Search properties…',
      searchText: (p) => '${p.id} ${p.name} ${p.type}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<PropertyRow>(
          title: 'ID',
          sortable: true,
          sortValue: (p) => p.id,
          exportValue: (p) => '${p.id}',
          cell: (_, p) => Text('${p.id}'),
          width: 80,
        ),
        AdminColumn<PropertyRow>(
          title: 'Name',
          sortable: true,
          sortValue: (p) => p.name,
          exportValue: (p) => p.name,
          cell: (_, p) => Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 260,
        ),
        AdminColumn<PropertyRow>(
          title: 'Type',
          sortable: true,
          sortValue: (p) => p.type,
          exportValue: (p) => p.type,
          cell: (_, p) => Text(p.type),
          width: 120,
        ),
        AdminColumn<PropertyRow>(
          title: 'Filter',
          sortable: true,
          sortValue: (p) => p.isFilterable ? 1 : 0,
          exportValue: (p) => p.isFilterable ? 'Yes' : 'No',
          cell: (_, p) => Text(p.isFilterable ? 'Yes' : 'No'),
          width: 100,
        ),
      ],
    );
  }
}
