import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';
import '../widgets/order_status_dropdown.dart';

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
    final items = visibleRows;
    final df = dateFormat;

    final borderColor = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08);

    final table = isWide
        ? AdminDataTable<OrderRow>(
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
          )
        : ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: items.length,
            separatorBuilder: (_, _) => Divider(height: 1, color: borderColor),
            itemBuilder: (context, i) {
              final o = items[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                  child: const Icon(Icons.receipt_long_rounded),
                ),
                title: Text('#${o.id} • ${o.customer}', maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('${o.payment} • ${o.total.toStringAsFixed(2)} • ${df.format(o.createdAt)}'),
                trailing: SizedBox(
                  width: 140,
                  child: OrderStatusDropdown(
                    status: o.status,
                    dense: true,
                    onChanged: (s) => onStatusChanged(o, s),
                  ),
                ),
              );
            },
          );

    final box = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Material(
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
                Tab(text: 'All (${allOrders.length})'),
                ...statuses.map((s) => Tab(text: '$s (${allOrders.where((o) => o.status == s).length})')),
              ],
            ),
          ),
          Divider(height: 1, color: borderColor),
          Expanded(child: table),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Orders', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
              ),
              IconButton(
                tooltip: 'Refresh',
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
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
