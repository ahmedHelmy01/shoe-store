import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/utils/asset_manager.dart';
import 'package:erp/core/constants/app_constants.dart';

class WebStoreCheckoutView extends StatefulWidget {
  const WebStoreCheckoutView({super.key});

  @override
  State<WebStoreCheckoutView> createState() => _WebStoreCheckoutViewState();
}

class _WebStoreCheckoutViewState extends State<WebStoreCheckoutView> {
  String selectedPayment = 'visa';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CommonAppBar(titleText: 'Checkout'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── 1. Delivery Address ─────────────────────
            _sectionHeader('Delivery Address', onAction: () {}),
            12.verticalSpace,
            AppCard(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.location_on_rounded, color: AppColors.primaryOrange, size: 24.sp),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Home Address', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700)),
                        4.verticalSpace,
                        Text(
                          '123 El-Nasr St, Maadi, Cairo, Egypt',
                          style: TextStyle(fontSize: 13.sp, color: theme.hintColor),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.check_circle_rounded, color: AppColors.primaryOrange, size: 22.sp),
                ],
              ),
            ),
            
            24.verticalSpace,

            // ─── 2. Payment Method ───────────────────────
            _sectionHeader('Payment Method'),
            12.verticalSpace,
            _buildPaymentOption('visa', 'Visa / Mastercard', AssetManager.visa),
            12.verticalSpace,
            _buildPaymentOption('instapay', 'InstaPay', AssetManager.instapay),
            12.verticalSpace,
            _buildPaymentOption('cash', 'Cash on Delivery', AssetManager.car, isAsset: true),

            24.verticalSpace,

            // ─── 3. Promo Code ──────────────────────────
            _sectionHeader('Promo Code'),
            12.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isDark ? theme.cardColor : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.primaryOrange.withValues(alpha: 0.3),
                  width: 1.5,
                  style: BorderStyle.solid, // Dash border would need custom painter, solid is cleaner here
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.confirmation_num_outlined, color: AppColors.primaryOrange, size: 24.sp),
                  12.horizontalSpace,
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter promo code',
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: TextStyle(fontSize: 14.sp, color: theme.hintColor),
                      ),
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  12.horizontalSpace,
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange.withValues(alpha: 0.1),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 14.sp, 
                        fontWeight: FontWeight.w900, 
                        color: AppColors.primaryOrange,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            40.verticalSpace,

            // ─── 4. Summary ─────────────────────────────
            AppCard(
              padding: EdgeInsets.all(20.w),
              backgroundColor: isDark ? theme.cardColor : Colors.grey[50],
              child: Column(
                children: [
                   _summaryRow('Order Amount', '\$423.00'),
                   12.verticalSpace,
                   _summaryRow('Delivery Fee', 'Free', isGreen: true),
                   20.verticalSpace,
                   const Divider(),
                   20.verticalSpace,
                   _summaryRow('Total Amount', '\$423.00', isTotal: true),
                ],
              ),
            ),
            
            32.verticalSpace,

            // Place Order Button
            AppButton(
              onPressed: () => AppNavigator.replace(context, AppRouteNames.webstoreOrderTrack),
              isGradient: true,
              child: Text(
                'Place Order',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, {VoidCallback? onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
        ),
        if (onAction != null)
          TextButton(
            onPressed: onAction,
            child: Text('Edit', style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  Widget _buildPaymentOption(String id, String name, String iconPath, {bool isAsset = false}) {
    final bool isSelected = selectedPayment == id;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppCard(
      onTap: () => setState(() => selectedPayment = id),
      border: isSelected ? Border.all(color: AppColors.primaryOrange, width: 2) : Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[200]!),
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 32.h,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Image.asset(iconPath, fit: BoxFit.contain),
          ),
          16.horizontalSpace,
          Expanded(
            child: Text(
              name,
              style: TextStyle(fontSize: 14.sp, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500),
            ),
          ),
          if (isSelected)
            Icon(Icons.radio_button_checked_rounded, color: AppColors.primaryOrange, size: 22.sp)
          else
            Icon(Icons.radio_button_off_rounded, color: theme.hintColor.withValues(alpha: 0.3), size: 22.sp),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false, bool isGreen = false}) {
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
