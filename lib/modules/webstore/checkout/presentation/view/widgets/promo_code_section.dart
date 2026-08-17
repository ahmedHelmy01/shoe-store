import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/checkout/presentation/view_model/checkout_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';

class PromoCodeSection extends ConsumerStatefulWidget {
  final TextEditingController promoController;
  final int? selectedAddressId;
  final int? selectedPaymentId;

  const PromoCodeSection({
    super.key,
    required this.promoController,
    required this.selectedAddressId,
    required this.selectedPaymentId,
  });

  @override
  ConsumerState<PromoCodeSection> createState() => _PromoCodeSectionState();
}

class _PromoCodeSectionState extends ConsumerState<PromoCodeSection> {
  String? couponStatusMessage;
  bool? isCouponValid;
  bool isValidatingCoupon = false;

  @override
  void initState() {
    super.initState();
    widget.promoController.addListener(_onPromoChanged);
  }

  @override
  void dispose() {
    widget.promoController.removeListener(_onPromoChanged);
    super.dispose();
  }

  void _onPromoChanged() {
    if (couponStatusMessage != null) {
      if (mounted) {
        setState(() {
          couponStatusMessage = null;
          isCouponValid = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          context,
          LocaleKeys.webstore.checkout.promo_code.tr(context: context),
        ),
        12.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: isDark ? theme.cardColor : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.primaryWine.withValues(alpha: 0.3),
              width: 1.5,
              style: BorderStyle.solid,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.confirmation_num_outlined,
                color: AppColors.primaryWine,
                size: 24.sp,
              ),
              12.horizontalSpace,
              Expanded(
                child: TextField(
                  controller: widget.promoController,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.webstore.checkout.enter_promo_code.tr(context: context),
                    border: InputBorder.none,
                    isDense: true,
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: theme.hintColor,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              12.horizontalSpace,
              TextButton(
                onPressed: isValidatingCoupon
                    ? null
                    : () async {
                        final code = widget.promoController.text.trim();
                        if (code.isEmpty) return;

                        setState(() {
                          isValidatingCoupon = true;
                          couponStatusMessage = null;
                          isCouponValid = null;
                        });

                        final result = await ref
                            .read(checkoutVmProvider.notifier)
                            .validateCoupon(code);

                        result.when(
                          success: (data) {
                            if (mounted) {
                              setState(() {
                                isValidatingCoupon = false;
                                isCouponValid = true;
                                final discountVal = data['discount'] ??
                                    data['value'] ??
                                    data['discount_value'];
                                final discountType =
                                    data['discount_type'] ?? data['type'];
                                if (discountVal != null) {
                                  final formattedType =
                                      discountType == 'percentage'
                                          ? '%'
                                          : LocaleKeys.webstore.checkout.currency_egp.tr(context: context);
                                  couponStatusMessage =
                                      LocaleKeys.webstore.checkout.coupon_applied_success_discount.tr(context: context, args: ['$discountVal$formattedType']);
                                } else {
                                  couponStatusMessage = data['message'] ??
                                      LocaleKeys.webstore.checkout.coupon_applied_success.tr(context: context);
                                }
                              });
                            }

                            ref
                                .read(checkoutVmProvider.notifier)
                                .calculateTotals(
                                  addressId: widget.selectedAddressId,
                                  paymentMethodId: widget.selectedPaymentId,
                                  couponCode: code,
                                );
                          },
                          failure: (error) {
                            if (mounted) {
                              setState(() {
                                isValidatingCoupon = false;
                                isCouponValid = false;
                                couponStatusMessage = error.message;
                              });
                            }
                          },
                        );
                      },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primaryWine.withValues(
                    alpha: 0.1,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: isValidatingCoupon
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryWine,
                        ),
                      )
                    : Text(
                        LocaleKeys.webstore.checkout.apply.tr(context: context,),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryWine,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ],
          ),
        ),
        if (couponStatusMessage != null) ...[
          8.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Icon(
                  isCouponValid == true
                      ? Icons.check_circle_outline_rounded
                      : Icons.error_outline_rounded,
                  color: isCouponValid == true ? Colors.green : Colors.red,
                  size: 18.sp,
                ),
                8.horizontalSpace,
                Expanded(
                  child: Text(
                    couponStatusMessage!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: isCouponValid == true ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
}
