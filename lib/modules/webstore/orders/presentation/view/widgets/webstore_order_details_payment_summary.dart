import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/constants/app_constants.dart';

class WebStoreOrderDetailsPaymentSummary extends StatelessWidget {
  final String subtotal;
  final String discountAmount;
  final String shippingCost;
  final String taxAmount;
  final String total;
  final String? couponCode;
  final String? notes;

  const WebStoreOrderDetailsPaymentSummary({
    super.key,
    required this.subtotal,
    required this.discountAmount,
    required this.shippingCost,
    required this.taxAmount,
    required this.total,
    this.couponCode,
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Coupon Notice (if exists) ──────────────────
        if (couponCode != null && couponCode!.trim().isNotEmpty) ...[
          AppCard(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Icon(Icons.local_offer_outlined, color: AppColors.success, size: 18.sp),
                8.horizontalSpace,
                Text(
                  LocaleKeys.webstore.orders.coupon.tr(context: context),
                  style: TextStyle(fontSize: 13.sp, color: theme.hintColor),
                ),
                Text(
                  couponCode!,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: AppColors.success),
                ),
                const Spacer(),
                Text(
                  '-$discountAmount ${AppConstants.currency}',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: AppColors.success),
                ),
              ],
            ),
          ),
          16.verticalSpace,
        ],

        // ─── Payment Summary ─────────────────────────
        Text(
          LocaleKeys.webstore.orders.payment_summary.tr(context: context),
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        12.verticalSpace,
        AppAnimation.fadeInUp(
          delay: const Duration(milliseconds: 200),
          child: AppCard(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _buildSummaryRow(theme, LocaleKeys.webstore.orders.subtotal.tr(context: context), subtotal),
                8.verticalSpace,
                if (double.tryParse(discountAmount) != null && double.parse(discountAmount) > 0) ...[
                  _buildSummaryRow(
                    theme,
                    LocaleKeys.webstore.orders.discount.tr(context: context),
                    '-$discountAmount',
                    valueColor: AppColors.success,
                  ),
                  8.verticalSpace,
                ],
                _buildSummaryRow(
                  theme,
                  LocaleKeys.webstore.orders.delivery_fee.tr(context: context),
                  shippingCost,
                ),
                8.verticalSpace,
                if (double.tryParse(taxAmount) != null && double.parse(taxAmount) > 0) ...[
                  _buildSummaryRow(
                    theme,
                    LocaleKeys.webstore.orders.tax.tr(context: context),
                    taxAmount,
                  ),
                  8.verticalSpace,
                ],
                Divider(color: theme.dividerColor.withValues(alpha: 0.5)),
                8.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.webstore.orders.total.tr(context: context),
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$total ${AppConstants.currency}',
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.primaryWine),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ─── Notes ───────────────────────────────────
        if (notes != null && notes!.isNotEmpty) ...[
          24.verticalSpace,
          Text(
            LocaleKeys.webstore.orders.notes.tr(context: context),
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          12.verticalSpace,
          AppCard(
            padding: EdgeInsets.all(16.w),
            child: Text(
              notes!,
              style: TextStyle(fontSize: 14.sp, color: theme.hintColor),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSummaryRow(ThemeData theme, String title, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 14.sp, color: theme.hintColor)),
        Text(
          '$value ${AppConstants.currency}',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: valueColor),
        ),
      ],
    );
  }
}
