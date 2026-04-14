import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/widgets/order_status_dropdown.dart';

class OrderDataTable extends StatelessWidget {
  final List<OrderRow> items;
  final DateFormat df;
  final void Function(OrderRow row, String status) onStatusChanged;

  const OrderDataTable({
    super.key,
    required this.items,
    required this.df,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<OrderRow>(
      rows: items,
      idOf: (o) => '${o.id}',
      exportBaseName: 'orders',
      searchHint: 'Search orders…',
      searchText: (o) => '${o.id} ${o.customer} ${o.status} ${o.payment} ${o.total}',
      columns: [
        AdminColumn<OrderRow>(
          title: 'Order #',
          sortable: true,
          sortValue: (o) => o.id,
          exportValue: (o) => '${o.id}',
          cell: (_, o) => Text('#${o.id}'),
          width: 110,
        ),
        AdminColumn<OrderRow>(
          title: 'Customer',
          sortable: true,
          sortValue: (o) => o.customer,
          exportValue: (o) => o.customer,
          cell: (_, o) => Text(o.customer, maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 220,
        ),
        AdminColumn<OrderRow>(
          title: 'Status',
          sortable: true,
          sortValue: (o) => o.status,
          exportValue: (o) => o.status,
          cell: (_, o) => OrderStatusDropdown(
            status: o.status,
            onChanged: (s) => onStatusChanged(o, s),
          ),
          width: 168,
        ),
        AdminColumn<OrderRow>(
          title: 'Payment',
          sortable: true,
          sortValue: (o) => o.payment,
          exportValue: (o) => o.payment,
          cell: (_, o) => Text(o.payment),
          width: 130,
        ),
        AdminColumn<OrderRow>(
          title: 'Items',
          sortable: true,
          sortValue: (o) => o.itemsCount,
          exportValue: (o) => '${o.itemsCount}',
          cell: (_, o) => Text('${o.itemsCount}'),
          width: 90,
        ),
        AdminColumn<OrderRow>(
          title: 'Total',
          sortable: true,
          sortValue: (o) => o.total,
          exportValue: (o) => o.total.toStringAsFixed(2),
          cell: (_, o) => Text(o.total.toStringAsFixed(2)),
          width: 110,
        ),
        AdminColumn<OrderRow>(
          title: 'Created',
          sortable: true,
          sortValue: (o) => o.createdAt.millisecondsSinceEpoch,
          exportValue: (o) => df.format(o.createdAt),
          cell: (_, o) => Text(df.format(o.createdAt)),
          width: 170,
        ),
      ],
    );
  }
}
