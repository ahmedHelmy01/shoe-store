import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class OrdersTable extends StatelessWidget {
  final List<OrderRow> items;
  final Function(OrderRow o) onEdit;
  final Function(OrderRow o)? onView;
  final Widget Function(BuildContext context, OrderRow o)? cardBuilder;

  OrdersTable({
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
          cell: (_, o) => _StatusBadge(status: o.status),
          width: 120,
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

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final translated = AdminLocalizations.translateStatus(context, status);
    final color = switch (translated.toLowerCase()) {
      'delivered' || 'completed' => Colors.green,
      'pending' || 'processing' => Colors.orange,
      'cancelled' => Colors.red,
      _ => Colors.blue,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        translated,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
