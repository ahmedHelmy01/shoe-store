import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/modules/webstore/orders/presentation/view_model/orders_providers.dart';
import 'package:erp/modules/webstore/cart/presentation/view_model/cart_view_model.dart';

class WebStoreOrderDetailsBottomBar extends ConsumerWidget {
  final int orderId;
  final String orderNumber;
  final bool isCancelled;
  final bool isDelivered;

  const WebStoreOrderDetailsBottomBar({
    super.key,
    required this.orderId,
    required this.orderNumber,
    required this.isCancelled,
    required this.isDelivered,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isReordering = ref.watch(webstoreReorderLoadingProvider);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Cancel / Track button
            if (!isCancelled && !isDelivered)
              Expanded(
                child: AppButton(
                  type: ButtonType.secondary,
                  onPressed: isReordering ? null : () => _showCancelDialog(context, ref),
                  child: Text(LocaleKeys.common.cancel.tr(context: context)),
                ),
              ),
            if (isDelivered)
              Expanded(
                child: AppButton(
                  type: ButtonType.secondary,
                  onPressed: isReordering ? null : () {
                    AppNavigator.push(context, AppRouteNames.webstoreOrderTrack, arguments: {
                      'order_id': orderId,
                      'order_number': orderNumber,
                    });
                  },
                  child: Text(LocaleKeys.webstore.orders.track_order.tr(context: context)),
                ),
              ),
            if (!isCancelled || isDelivered) 12.horizontalSpace,

            // Reorder Button
            Expanded(
              child: AppButton(
                type: isCancelled ? ButtonType.primary : ButtonType.outline,
                isGradient: isCancelled,
                isLoading: isReordering,
                onPressed: isReordering ? null : () => _handleReorder(context, ref),
                child: Text(
                  LocaleKeys.webstore.orders.reorder.tr(context: context),
                  style: TextStyle(
                    color: isCancelled ? Colors.white : theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            12.horizontalSpace,

            // Rate button
            Expanded(
              child: AppButton(
                type: isCancelled ? ButtonType.secondary : ButtonType.primary,
                isGradient: !isCancelled,
                onPressed: isReordering ? null : () {
                  AppNavigator.push(context, AppRouteNames.webstoreRateOrder, arguments: {
                    'order_id': orderId,
                  });
                },
                child: Text(
                  LocaleKeys.webstore.orders.rate_order.tr(context: context),
                  style: TextStyle(
                    color: !isCancelled ? Colors.white : theme.textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleReorder(BuildContext context, WidgetRef ref) async {
    ref.read(webstoreReorderLoadingProvider.notifier).setLoading(true);
    try {
      await ref.read(cartProvider.notifier).reorder(orderId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.webstore.orders.reorder_success.tr(context: context)),
            backgroundColor: Colors.green,
          ),
        );
        AppNavigator.replace(context, AppRouteNames.webstoreMain, arguments: {'initialIndex': 2});
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      ref.read(webstoreReorderLoadingProvider.notifier).setLoading(false);
    }
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocaleKeys.webstore.orders.cancel_order.tr(context: context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(LocaleKeys.webstore.orders.cancel_order_confirm.tr(context: context)),
            16.verticalSpace,
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                hintText: LocaleKeys.webstore.orders.cancel_reason_hint.tr(context: context),
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(LocaleKeys.common.cancel.tr(context: context)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final reason = reasonController.text.trim().isEmpty ? null : reasonController.text.trim();
              // Trigger the cancel
              ref.read(cancelOrderProvider((orderId: orderId, reason: reason)));
              // Refresh order detail
              ref.invalidate(orderDetailProvider(orderId));
              // Refresh orders list
              ref.invalidate(ordersListProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(LocaleKeys.webstore.orders.cancel_success.tr(context: context))),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(LocaleKeys.webstore.orders.confirm_cancel.tr(context: context)),
          ),
        ],
      ),
    );
  }
}
