import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/utils/asset_manager.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/modules/webstore/checkout/data/models/payment_method_model.dart';
import 'package:erp/modules/webstore/checkout/presentation/view_model/checkout_providers.dart';

import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';

class PaymentMethodSection extends ConsumerWidget {
  final int? selectedPaymentId;
  final String selectedPayment;
  final void Function(int? id, String code) onPaymentSelected;

  const PaymentMethodSection({
    super.key,
    required this.selectedPaymentId,
    required this.selectedPayment,
    required this.onPaymentSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentMethodsAsync = ref.watch(paymentMethodsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          context,
          LocaleKeys.webstore.checkout.payment_method.tr(context: context),
        ),
        12.verticalSpace,
        paymentMethodsAsync.when(
          loading: () => Column(
            children: List.generate(
              3,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: AppShimmer.box(height: 70.h, borderRadius: 16.r),
              ),
            ),
          ),
          error: (err, _) => Column(
            children: [
              _buildPaymentOption(
                context,
                'visa',
                LocaleKeys.webstore.checkout.visa_mastercard.tr(
                  context: context,
                ),
                AssetManager.visa,
              ),
              12.verticalSpace,
              _buildPaymentOption(
                context,
                'instapay',
                LocaleKeys.webstore.checkout.instapay.tr(context: context),
                AssetManager.instapay,
              ),
              12.verticalSpace,
              _buildPaymentOption(
                context,
                'cash',
                LocaleKeys.webstore.checkout.cash_on_delivery.tr(
                  context: context,
                ),
                AssetManager.car,
              ),
            ],
          ),
          data: (methods) {
            if (methods.isEmpty) {
              return Column(
                children: [
                  _buildPaymentOption(
                    context,
                    'visa',
                    LocaleKeys.webstore.checkout.visa_mastercard.tr(
                      context: context,
                    ),
                    AssetManager.visa,
                  ),
                  12.verticalSpace,
                  _buildPaymentOption(
                    context,
                    'instapay',
                    LocaleKeys.webstore.checkout.instapay.tr(context: context),
                    AssetManager.instapay,
                  ),
                  12.verticalSpace,
                  _buildPaymentOption(
                    context,
                    'cash',
                    LocaleKeys.webstore.checkout.cash_on_delivery.tr(
                      context: context,
                    ),
                    AssetManager.car,
                  ),
                ],
              );
            }

            // Auto-select first payment if none is selected
            if (selectedPaymentId == null) {
              Future.microtask(() {
                onPaymentSelected(methods.first.id, methods.first.code ?? 'cash');
              });
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: methods.length,
              separatorBuilder: (_, __) => 12.verticalSpace,
              itemBuilder: (context, index) =>
                  _buildDynamicPaymentOption(context, methods[index]),
            );
          },
        ),
      ],
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    String id,
    String name,
    String iconPath,
  ) {
    final bool isSelected = selectedPayment == id;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppCard(
      onTap: () => onPaymentSelected(null, id),
      border: isSelected
          ? Border.all(color: AppColors.primaryOrange, width: 2)
          : Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey[200]!,
            ),
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
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          if (isSelected)
            Icon(
              Icons.radio_button_checked_rounded,
              color: AppColors.primaryOrange,
              size: 22.sp,
            )
          else
            Icon(
              Icons.radio_button_off_rounded,
              color: theme.hintColor.withValues(alpha: 0.3),
              size: 22.sp,
            ),
        ],
      ),
    );
  }

  Widget _buildDynamicPaymentOption(
    BuildContext context,
    PaymentMethodModel method,
  ) {
    final bool isSelected = selectedPaymentId == method.id;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppCard(
      onTap: () => onPaymentSelected(method.id, method.code ?? 'cash'),
      border: isSelected
          ? Border.all(color: AppColors.primaryOrange, width: 2)
          : Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey[200]!,
            ),
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
            child: method.image != null && method.image!.startsWith('http')
                ? Image.network(
                    method.image!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => _fallbackIcon(method.code),
                  )
                : Image.asset(
                    _getPaymentAsset(method.code),
                    fit: BoxFit.contain,
                  ),
          ),
          16.horizontalSpace,
          Expanded(
            child: Text(
              method.name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          if (isSelected)
            Icon(
              Icons.radio_button_checked_rounded,
              color: AppColors.primaryOrange,
              size: 22.sp,
            )
          else
            Icon(
              Icons.radio_button_off_rounded,
              color: theme.hintColor.withValues(alpha: 0.3),
              size: 22.sp,
            ),
        ],
      ),
    );
  }

  Widget _fallbackIcon(String? code) {
    return Image.asset(_getPaymentAsset(code), fit: BoxFit.contain);
  }

  String _getPaymentAsset(String? code) {
    final c = code?.toLowerCase() ?? '';
    if (c.contains('visa') || c.contains('master') || c.contains('card')) {
      return AssetManager.visa;
    } else if (c.contains('insta')) {
      return AssetManager.instapay;
    } else {
      return AssetManager.car;
    }
  }
}
