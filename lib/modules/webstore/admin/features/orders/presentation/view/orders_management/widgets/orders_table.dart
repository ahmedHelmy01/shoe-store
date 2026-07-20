import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/widgets/order_status_badge.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class OrdersTable extends StatelessWidget {
  final List<OrderRow> items;
  final Function(OrderRow o) onEdit;
  final Function(OrderRow o)? onView;
  final Widget Function(BuildContext context, OrderRow o)? cardBuilder;

  const OrdersTable({
    super.key,
    required this.items,
    required this.onEdit,
    this.onView,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<OrderRow>(
      rows: items,
      idOf: (o) => '${o.id}',
      exportBaseName: 'orders',
      searchHint: AdminLocalizations.translate(context, 'search orders…'),
      searchText: (o) => '${o.id} ${o.orderNumber} ${o.status}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<OrderRow>(
          title: AdminLocalizations.translate(context, 'id'),
          sortable: true,
          sortValue: (o) => o.id,
          exportValue: (o) => '${o.id}',
          cell: (_, o) => Text('#${o.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
          width: 80,
        ),
        AdminColumn<OrderRow>(
          title: AdminLocalizations.translate(context, 'order number'),
          sortable: true,
          sortValue: (o) => o.orderNumber,
          exportValue: (o) => o.orderNumber,
          cell: (_, o) => Text(o.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
          width: 200,
        ),
        AdminColumn<OrderRow>(
          title: AdminLocalizations.translate(context, 'total'),
          sortable: true,
          sortValue: (o) => o.totalPrice,
          exportValue: (o) => '${o.totalPrice}',
          cell: (_, o) => Text('\$${o.totalPrice.toStringAsFixed(2)}'),
          width: 100,
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
          width: 160,
        ),
        AdminColumn<OrderRow>(
          title: AdminLocalizations.translate(context, 'actions'),
          cell: (_, o) => AdminTableActionsCell<OrderRow>(
            row: o,
            onView: onView != null ? (item) => onView!(item) : null,
            onEdit: onEdit,
          ),
          width: 130,
        ),
      ],
    );
  }
}
