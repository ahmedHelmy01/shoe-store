import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/presentation/features/orders/order_list/widgets/order_status_dot.dart';

class OrderStatusDropdown extends StatelessWidget {
  final String status;
  final ValueChanged<String> onChanged;
  final bool dense;

  const OrderStatusDropdown({
    super.key,
    required this.status,
    required this.onChanged,
    this.dense = false,
  });

  static const allStatuses = [
    'Pending',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: allStatuses.contains(status) ? status : 'Pending',
        isDense: dense,
        borderRadius: BorderRadius.circular(12),
        padding: EdgeInsets.symmetric(horizontal: dense ? 4 : 8),
        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
        items: allStatuses
            .map(
              (s) => DropdownMenuItem(
                value: s,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OrderStatusDot(status: s),
                    const SizedBox(width: 8),
                    Text(s),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
        selectedItemBuilder: (context) => allStatuses
            .map(
              (s) => Align(
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OrderStatusDot(status: s, small: true),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        s,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
