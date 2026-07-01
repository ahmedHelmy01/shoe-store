import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class OrderStatusTabs extends StatelessWidget {
  final TabController tabController;
  final List<String> statuses;
  final List<OrderRow> allOrders;
  final ThemeData theme;

  const OrderStatusTabs({
    super.key,
    required this.tabController,
    required this.statuses,
    required this.allOrders,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.center,
        labelColor: AppColors.primaryOrange,
        unselectedLabelColor: theme.textTheme.bodyMedium?.color,
        indicatorColor: AppColors.primaryOrange,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
        unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        tabs: [
          Tab(text: '${AdminLocalizations.translate(context, 'all')} (${allOrders.length})'),
          ...statuses.map((s) => Tab(text: '${AdminLocalizations.translateStatus(context, s)} (${allOrders.where((o) => o.status == s).length})')),
        ],
      ),
    );
  }
}
