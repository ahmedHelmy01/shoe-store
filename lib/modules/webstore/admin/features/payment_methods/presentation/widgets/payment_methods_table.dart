import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/data/models/payment_method_row.dart';

class PaymentMethodsTable extends StatelessWidget {
  final List<PaymentMethodRow> items;
  final Function(PaymentMethodRow m) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, PaymentMethodRow m)? cardBuilder;

  const PaymentMethodsTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<PaymentMethodRow>(
      rows: items,
      idOf: (p) => '${p.id}',
      exportBaseName: 'payment_methods',
      searchHint: 'Search methods…',
      searchText: (p) => '${p.id} ${p.title} ${p.type}',
      cardBuilder: cardBuilder,
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
        AdminColumn<PaymentMethodRow>(
          title: 'Actions',
          cell: (_, p) => AdminTableActionsCell<PaymentMethodRow>(
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
