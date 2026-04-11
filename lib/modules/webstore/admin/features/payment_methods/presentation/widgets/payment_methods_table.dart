import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import '../../data/models/payment_method_row.dart';

class PaymentMethodsTable extends StatelessWidget {
  final List<PaymentMethodRow> items;

  const PaymentMethodsTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<PaymentMethodRow>(
      rows: items,
      idOf: (p) => '${p.id}',
      exportBaseName: 'payment_methods',
      searchHint: 'Search methods…',
      searchText: (p) => '${p.id} ${p.title} ${p.type}',
      columns: [
        AdminColumn<PaymentMethodRow>(
          title: 'ID',
          sortable: true,
          sortValue: (p) => p.id,
          exportValue: (p) => '${p.id}',
          cell: (_, p) => Text('${p.id}'),
          width: 80,
        ),
        AdminColumn<PaymentMethodRow>(
          title: 'Title',
          sortable: true,
          sortValue: (p) => p.title,
          exportValue: (p) => p.title,
          cell: (_, p) => Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 280,
        ),
        AdminColumn<PaymentMethodRow>(
          title: 'Type',
          sortable: true,
          sortValue: (p) => p.type,
          exportValue: (p) => p.type,
          cell: (_, p) => Text(p.type),
          width: 140,
        ),
        AdminColumn<PaymentMethodRow>(
          title: 'Active',
          sortable: true,
          sortValue: (p) => p.isActive ? 1 : 0,
          exportValue: (p) => p.isActive ? 'Yes' : 'No',
          cell: (_, p) => Text(p.isActive ? 'Yes' : 'No'),
          width: 100,
        ),
      ],
    );
  }
}
