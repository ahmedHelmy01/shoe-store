import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/payment_statuses/data/models/payment_status_row.dart';

class PaymentStatusesTable extends StatelessWidget {
  final List<PaymentStatusRow> items;
  final Function(PaymentStatusRow s) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, PaymentStatusRow s)? cardBuilder;

  const PaymentStatusesTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<PaymentStatusRow>(
      rows: items,
      idOf: (s) => '${s.id}',
      exportBaseName: 'payment_statuses',
      searchHint: 'Search statuses…',
      searchText: (s) => '${s.id} ${s.name}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<PaymentStatusRow>(
          title: 'ID',
          sortable: true,
          sortValue: (s) => s.id,
          exportValue: (s) => '${s.id}',
          cell: (_, s) => Text('${s.id}'),
          width: 80,
        ),
        AdminColumn<PaymentStatusRow>(
          title: 'Name',
          sortable: true,
          sortValue: (s) => s.name,
          exportValue: (s) => s.name,
          cell: (_, s) => Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 280,
        ),
        AdminColumn<PaymentStatusRow>(
          title: 'Color',
          sortable: false,
          cell: (_, p) => Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Color(int.parse(p.color.replaceFirst('#', '0xFF'))),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(p.color),
            ],
          ),
          width: 140,
        ),
        AdminColumn<PaymentStatusRow>(
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
