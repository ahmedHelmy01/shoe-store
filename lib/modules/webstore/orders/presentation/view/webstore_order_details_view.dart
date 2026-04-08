import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/router/app_navigator.dart';

class WebStoreOrderDetailsView extends StatelessWidget {
  const WebStoreOrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(titleText: LocaleKeys.webstore.orders.details.tr()),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status summary
            AppAnimation.fadeInDown(
              child: AppCard(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${LocaleKeys.webstore.orders.order_number.tr()}: #ORD-12345',
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            LocaleKeys.webstore.orders.status_delivered.tr(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    12.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${LocaleKeys.webstore.orders.date.tr()}:', style: TextStyle(color: theme.hintColor, fontSize: 14.sp)),
                        Text('Oct 15, 2023', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            24.verticalSpace,

            // Order Items
            Text(
              LocaleKeys.webstore.orders.order_items.tr(),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            12.verticalSpace,
            AppAnimation.fadeInUp(
              delay: const Duration(milliseconds: 100),
              child: AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildOrderItem(
                      context: context,
                      name: 'NIKE Air Max 2090',
                      price: '450.00',
                      qty: 1,
                      image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=200&auto=format&fit=crop',
                      isDark: isDark,
                    ),
                    Divider(height: 1, thickness: 1, color: theme.dividerColor.withValues(alpha: 0.5)),
                    _buildOrderItem(
                      context: context,
                      name: 'Sony WH-1000XM4',
                      price: '440.00',
                      qty: 1,
                      image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=200&auto=format&fit=crop',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),

            24.verticalSpace,

            // Order Summary
            Text(
              LocaleKeys.webstore.orders.payment_summary.tr(),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            12.verticalSpace,
            AppAnimation.fadeInUp(
              delay: const Duration(milliseconds: 200),
              child: AppCard(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    _buildSummaryRow(theme, LocaleKeys.webstore.orders.subtotal.tr(), '890.00'),
                    8.verticalSpace,
                    _buildSummaryRow(theme, LocaleKeys.webstore.orders.delivery_fee.tr(), '0.00'),
                    8.verticalSpace,
                    Divider(color: theme.dividerColor.withValues(alpha: 0.5)),
                    8.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocaleKeys.webstore.orders.total.tr(), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                        Text('890.00 ${AppConstants.currency}', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.primaryOrange)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            40.verticalSpace,
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
              Expanded(
                child: AppButton(
                  type: ButtonType.secondary,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(LocaleKeys.webstore.orders.added_to_cart.tr())),
                    );
                    AppNavigator.pushAndRemoveUntil(context, AppRouteNames.webstoreMain);
                  },
                  child: Text(LocaleKeys.webstore.orders.reorder.tr()),
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: AppButton(
                  onPressed: () {
                    AppNavigator.push(context, AppRouteNames.webstoreRateOrder);
                  },
                  isGradient: true,
                  child: Text(LocaleKeys.webstore.orders.rate_order.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem({
    required BuildContext context,
    required String name,
    required String price,
    required int qty,
    required String image,
    required bool isDark,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.network(image, width: 64.w, height: 64.w, fit: BoxFit.cover),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                4.verticalSpace,
                Text(
                  '${LocaleKeys.webstore.orders.quantity.tr()} $qty',
                  style: TextStyle(fontSize: 12.sp, color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ),
          Text(
            '$price ${AppConstants.currency}',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(ThemeData theme, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 14.sp, color: theme.hintColor)),
        Text('$value ${AppConstants.currency}', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
