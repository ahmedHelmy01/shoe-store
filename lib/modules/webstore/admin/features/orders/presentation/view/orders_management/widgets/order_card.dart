import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_card_popup_menu.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/widgets/order_status_badge.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class OrderCard extends StatelessWidget {
  final OrderRow order;
  final VoidCallback? onView;
  final VoidCallback onEdit;

  const OrderCard({
    super.key,
    required this.order,
    this.onView,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${order.id}',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.orderNumber,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.primaryColor),
                    ),
                  ],
                ),
              ),
              OrderStatusBadge(
                status: order.status,
                hexColor: order.statusColor,
                dense: true,
              ),
              const SizedBox(width: 8),
              AdminCardPopupMenu(
                onView: onView,
                onEdit: onEdit,
                editLabel: AdminLocalizations.translate(context, 'manage'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AdminLocalizations.translate(context, 'total')}:',
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6)),
              ),
              Text(
                '\$${order.totalPrice.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, color: theme.primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
