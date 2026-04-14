import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';

import 'widgets/order_status_tabs.dart';
import 'widgets/order_data_table.dart';
import 'widgets/order_mobile_list.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';

class OrderListView extends StatelessWidget {
  final TabController tabController;
  final List<String> statuses;
  final List<OrderRow> allOrders;
  final List<OrderRow> visibleRows;
  final DateFormat dateFormat;
  final void Function(OrderRow row, String status) onStatusChanged;
  final VoidCallback onRefresh;

  const OrderListView({
    super.key,
    required this.tabController,
    required this.statuses,
    required this.allOrders,
    required this.visibleRows,
    required this.dateFormat,
    required this.onStatusChanged,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.sizeOf(context).width >= 980;
    final borderColor = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08);

    final tableContent = isWide
        ? OrderDataTable(
            items: visibleRows,
            df: dateFormat,
            onStatusChanged: onStatusChanged,
          )
        : OrderMobileList(
            items: visibleRows,
            df: dateFormat,
            isDark: isDark,
            borderColor: borderColor,
            onStatusChanged: onStatusChanged,
          );

    final box = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          OrderStatusTabs(
            tabController: tabController,
            statuses: statuses,
            allOrders: allOrders,
            theme: theme,
          ),
          Divider(height: 1, color: borderColor),
          Expanded(child: tableContent),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminPageHeader(
            title: 'Orders',
            onRefresh: onRefresh,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: AppAnimation.fadeInUp(
              duration: const Duration(milliseconds: 420),
              child: box,
            ),
          ),
        ],
      ),
    );
  }
}
