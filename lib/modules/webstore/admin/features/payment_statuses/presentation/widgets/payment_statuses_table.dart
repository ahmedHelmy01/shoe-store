import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import '../../data/models/payment_status_row.dart';

class PaymentStatusesTable extends StatelessWidget {
  final List<PaymentStatusRow> items;

  const PaymentStatusesTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<PaymentStatusRow>(
      rows: items,
      idOf: (p) => '${p.id}',
      exportBaseName: 'payment_statuses',
      searchHint: 'Search statuses…',
      searchText: (p) => '${p.id} ${p.name}',
      columns: [
        AdminColumn<PaymentStatusRow>(
          title: 'ID',
          sortable: true,
          sortValue: (p) => p.id,
          exportValue: (p) => '${p.id}',
          cell: (_, p) => Text('${p.id}'),
          width: 80,
        ),
        AdminColumn<PaymentStatusRow>(
          title: 'Name',
          sortable: true,
          sortValue: (p) => p.name,
          exportValue: (p) => p.name,
          cell: (_, p) => Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
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
