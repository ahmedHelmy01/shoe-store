import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/modules/webstore/cart/presentation/view_model/cart_view_model.dart';
import 'package:erp/modules/webstore/checkout/presentation/view_model/checkout_providers.dart';
import 'package:erp/modules/webstore/checkout/presentation/view_model/checkout_view_model.dart';
import 'package:erp/modules/webstore/checkout/presentation/state/checkout_state.dart';

class CheckoutSummarySection extends ConsumerWidget {
  const CheckoutSummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Watch cart provider to react to changes, and read cart notifier
    ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final checkoutState = ref.watch(checkoutVmProvider);

    double subtotal = cartNotifier.subtotal;
    double shipping = cartNotifier.shipping;
    double discount = 0.0;
    double total = cartNotifier.total;

    if (checkoutState is CheckoutCalculated) {
      final calculations = checkoutState.calculations;
      subtotal = (calculations['subtotal'] as num?)?.toDouble() ?? subtotal;
      shipping = (calculations['shipping'] as num?)?.toDouble() ?? shipping;
      discount = (calculations['discount'] as num?)?.toDouble() ?? discount;
      total = (calculations['total'] as num?)?.toDouble() ?? total;
    }

    return AppCard(
      padding: EdgeInsets.all(20.w),
      backgroundColor: isDark ? theme.cardColor : Colors.grey[50],
      child: Column(
        children: [
          _summaryRow(
            context,
            LocaleKeys.webstore.checkout.order_amount.tr(context: context),
            '\$${subtotal.toStringAsFixed(2)}',
          ),
          12.verticalSpace,
          _summaryRow(
            context,
            LocaleKeys.webstore.checkout.delivery_fee.tr(context: context),
            '\$${shipping.toStringAsFixed(0)}',
          ),
          if (discount > 0) ...[
            12.verticalSpace,
            _summaryRow(
              context,
              'الخصم',
              '-\$${discount.toStringAsFixed(2)}',
              isGreen: true,
            ),
          ],
          20.verticalSpace,
          const Divider(),
          20.verticalSpace,
          _summaryRow(
            context,
            LocaleKeys.webstore.checkout.total_amount.tr(context: context),
            '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
    bool isGreen = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
            color: isTotal ? null : Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
            color: isGreen ? Colors.green : null,
          ),
        ),
      ],
    );
  }
}
