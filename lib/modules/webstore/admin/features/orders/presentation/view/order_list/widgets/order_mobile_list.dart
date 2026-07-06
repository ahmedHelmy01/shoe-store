import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/widgets/order_status_badge.dart';

class OrderMobileList extends StatelessWidget {
  final List<OrderRow> items;
  final DateFormat df;
  final bool isDark;
  final Color borderColor;
  final void Function(OrderRow row, String status) onStatusChanged;

  const OrderMobileList({
    super.key,
    required this.items,
    required this.df,
    required this.isDark,
    required this.borderColor,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: borderColor),
      itemBuilder: (context, i) {
        final o = items[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
            child: const Icon(Icons.receipt_long_rounded),
          ),
          title: Text(o.orderNumber, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text('${o.payment} • ${o.total.toStringAsFixed(2)} • ${df.format(o.createdAt)}'),
          trailing: OrderStatusBadge(
            status: o.status,
            hexColor: o.statusColor,
            dense: true,
          ),
        );
      },
    );
  }
}
