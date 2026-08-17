import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/router/app_navigator.dart';

class WebStoreOrderCardWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final bool isDark;

  const WebStoreOrderCardWidget({
    super.key,
    required this.order,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderId = (order['id'] as num?)?.toInt() ?? 0;
    final orderNumber = order['order_number']?.toString() ?? '#$orderId';
    final total = order['total']?.toString() ?? '0.00';
    final createdAt = order['created_at'] != null
        ? DateTime.tryParse(order['created_at'].toString())
        : null;
    final dateStr = createdAt != null
        ? DateFormat('MMM d, yyyy').format(createdAt)
        : '';
    final statusName = _getStatusName(context, order);
    final statusColor = _getStatusColor(order);
    final items = order['items'] is List ? order['items'] as List<dynamic> : [];
    final rawPayment = order['payment_method'];
    final Map<String, dynamic>? paymentMethod = rawPayment is Map<String, dynamic>
        ? rawPayment
        : (rawPayment is String
            ? {
                'name': rawPayment,
                'type': rawPayment.toLowerCase().contains('card') ? 'card' : 'cash',
              }
            : null);
    final couponCode = order['coupon_code']?.toString();
    final isCancelled = order['cancelled_at'] != null && order['cancelled_at'].toString().trim().isNotEmpty;

    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, AppRouteNames.webstoreOrderDetails, arguments: {
          'order_id': orderId,
        });
      },
      child: AppCard(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Order Number & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    orderNumber,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
            12.verticalSpace,

            // Status & Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    statusName,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                Text(
                  '$total ${AppConstants.currency}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryWine,
                  ),
                ),
              ],
            ),

            12.verticalSpace,

            // Payment method & coupon info
            Row(
              children: [
                if (paymentMethod != null) ...[
                  Icon(
                    paymentMethod['type'] == 'card' ? Icons.credit_card : Icons.money,
                    size: 14.sp,
                    color: theme.hintColor,
                  ),
                  4.horizontalSpace,
                  Text(
                    paymentMethod['name']?.toString() ?? '',
                    style: TextStyle(fontSize: 12.sp, color: theme.hintColor),
                  ),
                ],
                if (couponCode != null && couponCode.trim().isNotEmpty) ...[
                  8.horizontalSpace,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      couponCode,
                      style: TextStyle(fontSize: 10.sp, color: AppColors.success, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),

            10.verticalSpace,
            Divider(color: theme.dividerColor.withValues(alpha: 0.5)),
            10.verticalSpace,

            // Items summary row
            Row(
              children: [
                Icon(Icons.shopping_bag_outlined, size: 16.sp, color: theme.hintColor),
                6.horizontalSpace,
                Expanded(
                  child: Text(
                    items.length == 1
                        ? (items.first['product_name']?.toString() ?? '')
                        : '${items.length} ${items.length > 1 ? LocaleKeys.webstore.orders.items_count.tr(context: context) : LocaleKeys.webstore.orders.item_count.tr(context: context)}',
                    style: TextStyle(fontSize: 13.sp, color: theme.hintColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isCancelled)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cancel_outlined, size: 12.sp, color: Colors.red),
                        4.horizontalSpace,
                        Text(
                          LocaleKeys.webstore.orders.status_cancelled.tr(context: context),
                          style: TextStyle(fontSize: 11.sp, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                if (!isCancelled)
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                    ),
                    child: Icon(Icons.arrow_forward_ios_rounded, size: 14.sp),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusName(BuildContext context, Map<String, dynamic> order) {
    final status = order['status'];
    if (status is Map) {
      return status['name']?.toString() ?? LocaleKeys.webstore.orders.status_pending.tr(context: context);
    }
    if (status is String) {
      final s = status.toLowerCase();
      if (s == 'processing') return LocaleKeys.webstore.orders.status_processing.tr(context: context);
      if (s == 'shipped') return LocaleKeys.webstore.orders.status_shipped.tr(context: context);
      if (s == 'delivered') return LocaleKeys.webstore.orders.status_delivered.tr(context: context);
      if (s == 'cancelled') return LocaleKeys.webstore.orders.status_cancelled.tr(context: context);
      return status;
    }
    
    // Fallback to checking dates (with empty check)
    if (order['cancelled_at'] != null && order['cancelled_at'].toString().trim().isNotEmpty) {
      return LocaleKeys.webstore.orders.status_cancelled.tr(context: context);
    }
    if (order['delivered_at'] != null && order['delivered_at'].toString().trim().isNotEmpty) {
      return LocaleKeys.webstore.orders.status_delivered.tr(context: context);
    }
    if (order['shipped_at'] != null && order['shipped_at'].toString().trim().isNotEmpty) {
      return LocaleKeys.webstore.orders.status_shipped.tr(context: context);
    }
    return LocaleKeys.webstore.orders.status_pending.tr(context: context);
  }

  Color _getStatusColor(Map<String, dynamic> order) {
    final status = order['status'];
    if (status is Map && status['color'] != null) {
      final colorStr = status['color'].toString();
      try {
        final hex = colorStr.replaceAll('#', '');
        if (hex.length == 6) {
          return Color(int.parse('FF$hex', radix: 16));
        } else if (hex.length == 8) {
          return Color(int.parse(hex, radix: 16));
        }
      } catch (_) {}
    }
    
    // Fallback to dates (with empty check)
    if (order['cancelled_at'] != null && order['cancelled_at'].toString().trim().isNotEmpty) {
      return Colors.red;
    }
    if (order['delivered_at'] != null && order['delivered_at'].toString().trim().isNotEmpty) {
      return AppColors.success;
    }
    if (order['shipped_at'] != null && order['shipped_at'].toString().trim().isNotEmpty) {
      return AppColors.info;
    }
    return AppColors.warning;
  }
}
