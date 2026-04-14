import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';

class OrdersTable extends StatelessWidget {
  final List<OrderRow> items;
  final Function(OrderRow o) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, OrderRow o)? cardBuilder;

  const OrdersTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<OrderRow>(
      rows: items,
      idOf: (o) => '${o.id}',
      exportBaseName: 'orders',
      searchHint: 'Search orders…',
      searchText: (o) => '${o.id} ${o.customerName} ${o.status}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<OrderRow>(
          title: 'ID',
          sortable: true,
          sortValue: (o) => o.id,
          exportValue: (o) => '${o.id}',
          cell: (_, o) => Text('#${o.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
          width: 80,
        ),
        AdminColumn<OrderRow>(
          title: 'Customer',
          sortable: true,
          sortValue: (o) => o.customerName,
          exportValue: (o) => o.customerName,
          cell: (_, o) => Text(o.customerName),
          width: 250,
        ),
        AdminColumn<OrderRow>(
          title: 'Total',
          sortable: true,
          sortValue: (o) => o.totalPrice,
          exportValue: (o) => '${o.totalPrice}',
          cell: (_, o) => Text('\$${o.totalPrice.toStringAsFixed(2)}'),
          width: 100,
        ),
        AdminColumn<OrderRow>(
          title: 'Status',
          sortable: true,
          sortValue: (o) => o.status,
          exportValue: (o) => o.status,
          cell: (_, o) => _StatusBadge(status: o.status),
          width: 120,
        ),
        AdminColumn<OrderRow>(
          title: 'Actions',
          cell: (_, o) => Row(
            children: [
              IconButton(onPressed: () => onEdit(o), icon: const Icon(Icons.edit_outlined, size: 20)),
              IconButton(onPressed: () => onDelete(o.id), icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red)),
            ],
          ),
          width: 120,
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
    final color = switch (status.toLowerCase()) {
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
        status,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
