import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_error_widget/app_error_widget.dart';
import 'package:erp/modules/webstore/orders/presentation/view_model/orders_providers.dart';
import 'package:erp/modules/webstore/orders/presentation/view/widgets/webstore_order_details_summary_card.dart';
import 'package:erp/modules/webstore/orders/presentation/view/widgets/webstore_order_details_address_card.dart';
import 'package:erp/modules/webstore/orders/presentation/view/widgets/webstore_order_details_item_tile.dart';
import 'package:erp/modules/webstore/orders/presentation/view/widgets/webstore_order_details_payment_summary.dart';
import 'package:erp/modules/webstore/orders/presentation/view/widgets/webstore_order_details_bottom_bar.dart';
import 'package:erp/core/constants/app_constants.dart';

class WebStoreOrderDetailsView extends ConsumerWidget {
  final int orderId;

  const WebStoreOrderDetailsView({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final detailAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(titleText: LocaleKeys.webstore.orders.details.tr(context: context)),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, stack) => Center(
          child: AppErrorWidget(
            errorMessage: err.toString(),
            onRetry: () => ref.invalidate(orderDetailProvider(orderId)),
          ),
        ),
        data: (response) {
          final order = (response['data'] as Map<String, dynamic>?) ?? response;
          return _buildContent(context, ref, theme, order);
        },
      ),
      bottomNavigationBar: detailAsync.whenOrNull(
        data: (response) {
          final order = (response['data'] as Map<String, dynamic>?) ?? response;
          final isCancelled = order['cancelled_at'] != null;
          final isDelivered = order['delivered_at'] != null;
          final orderNumber = order['order_number']?.toString() ?? '#$orderId';

          return WebStoreOrderDetailsBottomBar(
            orderId: orderId,
            orderNumber: orderNumber,
            isCancelled: isCancelled,
            isDelivered: isDelivered,
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, ThemeData theme, Map<String, dynamic> order) {
    final orderNumber = order['order_number']?.toString() ?? '#$orderId';
    final statusName = _getStatusName(context, order);
    final statusColor = _getStatusColor(order);
    final createdAt = order['created_at'] != null ? DateTime.tryParse(order['created_at'].toString()) : null;
    final dateStr = createdAt != null ? DateFormat('MMM d, yyyy').format(createdAt) : '';
    final items = order['items'] as List<dynamic>? ?? [];
    final subtotal = order['subtotal']?.toString() ?? '0.00';
    final discountAmount = order['discount_amount']?.toString() ?? '0.00';
    final shippingCost = order['shipping_cost']?.toString() ?? '0.00';
    final taxAmount = order['tax_amount']?.toString() ?? '0.00';
    final total = order['total']?.toString() ?? '0.00';
    final couponCode = order['coupon_code']?.toString();
    final paymentMethod = order['payment_method'] as Map<String, dynamic>?;
    final address = order['address'] as Map<String, dynamic>?;
    final isCancelled = order['cancelled_at'] != null;
    final cancelledReason = order['cancelled_reason']?.toString();
    final notes = order['notes']?.toString();

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Order Status Summary ────────────────────
          AppAnimation.fadeInDown(
            child: WebStoreOrderDetailsSummaryCard(
              orderNumber: orderNumber,
              statusName: statusName,
              statusColor: statusColor,
              dateStr: dateStr,
              paymentMethod: paymentMethod,
              isCancelled: isCancelled,
              cancelledReason: cancelledReason,
            ),
          ),

          // ─── Delivery Address ────────────────────────
          if (address != null) ...[
            24.verticalSpace,
            WebStoreOrderDetailsAddressCard(address: address),
          ],

          24.verticalSpace,

          // ─── Order Items ─────────────────────────────
          Text(
            LocaleKeys.webstore.orders.order_items.tr(context: context),
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          12.verticalSpace,
          AppAnimation.fadeInUp(
            delay: const Duration(milliseconds: 100),
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    if (i > 0) Divider(height: 1, thickness: 1, color: theme.dividerColor.withValues(alpha: 0.5)),
                    WebStoreOrderDetailsItemTile(item: items[i] as Map<String, dynamic>),
                  ],
                ],
              ),
            ),
          ),

          24.verticalSpace,

          // ─── Payment Summary ─────────────────────────
          WebStoreOrderDetailsPaymentSummary(
            subtotal: subtotal,
            discountAmount: discountAmount,
            shippingCost: shippingCost,
            taxAmount: taxAmount,
            total: total,
            couponCode: couponCode,
            notes: notes,
          ),

          40.verticalSpace,
        ],
      ),
    );
  }

  String _getStatusName(BuildContext context, Map<String, dynamic> order) {
    if (order['cancelled_at'] != null) return LocaleKeys.webstore.orders.status_cancelled.tr(context: context);
    if (order['delivered_at'] != null) return LocaleKeys.webstore.orders.status_delivered.tr(context: context);
    if (order['shipped_at'] != null) return LocaleKeys.webstore.orders.status_shipped.tr(context: context);
    final status = order['status'];
    if (status is Map) {
      final name = status['name']?.toString().toLowerCase() ?? 'pending';
      if (name == 'processing') return LocaleKeys.webstore.orders.status_processing.tr(context: context);
      if (name == 'shipped') return LocaleKeys.webstore.orders.status_shipped.tr(context: context);
      if (name == 'delivered') return LocaleKeys.webstore.orders.status_delivered.tr(context: context);
      if (name == 'cancelled') return LocaleKeys.webstore.orders.status_cancelled.tr(context: context);
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
    return LocaleKeys.webstore.orders.status_pending.tr(context: context);
  }

  Color _getStatusColor(Map<String, dynamic> order) {
    if (order['cancelled_at'] != null) return Colors.red;
    if (order['delivered_at'] != null) return AppColors.success;
    if (order['shipped_at'] != null) return AppColors.info;
    return AppColors.warning;
  }
}
