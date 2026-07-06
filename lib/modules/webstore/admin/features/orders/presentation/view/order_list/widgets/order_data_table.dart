import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/widgets/order_status_badge.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

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
      searchHint: AdminLocalizations.translate(context, 'search orders…'),
      searchText: (o) => '${o.id} ${o.orderNumber} ${o.status} ${o.payment} ${o.total}',
      columns: [
        AdminColumn<OrderRow>(
          title: AdminLocalizations.translate(context, 'order #'),
          sortable: true,
          sortValue: (o) => o.id,
          exportValue: (o) => '${o.id}',
          cell: (_, o) => Text('#${o.id}'),
          width: 110,
        ),
        AdminColumn<OrderRow>(
          title: AdminLocalizations.translate(context, 'order number'),
          sortable: true,
          sortValue: (o) => o.orderNumber,
          exportValue: (o) => o.orderNumber,
          cell: (_, o) => Text(o.orderNumber, maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 220,
        ),
        AdminColumn<OrderRow>(
          title: AdminLocalizations.translate(context, 'status'),
          sortable: true,
          sortValue: (o) => o.status,
          exportValue: (o) => o.status,
          cell: (_, o) => OrderStatusBadge(
            status: o.status,
            hexColor: o.statusColor,
          ),
          width: 168,
        ),
        AdminColumn<OrderRow>(
          title: AdminLocalizations.translate(context, 'payment'),
          sortable: true,
          sortValue: (o) => o.payment,
          exportValue: (o) => o.payment,
          cell: (_, o) => Text(o.payment),
          width: 130,
        ),
        AdminColumn<OrderRow>(
          title: AdminLocalizations.translate(context, 'items'),
          sortable: true,
          sortValue: (o) => o.itemsCount,
          exportValue: (o) => '${o.itemsCount}',
          cell: (_, o) => Text('${o.itemsCount}'),
          width: 90,
        ),
        AdminColumn<OrderRow>(
          title: AdminLocalizations.translate(context, 'total'),
          sortable: true,
          sortValue: (o) => o.total,
          exportValue: (o) => o.total.toStringAsFixed(2),
          cell: (_, o) => Text(o.total.toStringAsFixed(2)),
          width: 110,
        ),
        AdminColumn<OrderRow>(
          title: AdminLocalizations.translate(context, 'created'),
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
