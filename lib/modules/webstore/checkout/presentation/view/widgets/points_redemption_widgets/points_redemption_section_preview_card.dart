import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';

class PointsRedemptionSectionPreviewCard extends StatelessWidget {
  final bool isPreviewLoading;
  final String? previewError;
  final double? previewDiscount;

  const PointsRedemptionSectionPreviewCard({
    super.key,
    required this.isPreviewLoading,
    this.previewError,
    this.previewDiscount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = previewError != null && previewError!.isNotEmpty;
    final hasDiscount = previewDiscount != null && previewDiscount! > 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: hasError ? Colors.red.withValues(alpha: 0.06) : Colors.green.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: hasError ? Colors.red.withValues(alpha: 0.2) : Colors.green.withValues(alpha: 0.2),
        ),
      ),
      child: isPreviewLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 16.w, height: 16.w, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
                8.horizontalSpace,
                Text(
                  LocaleKeys.webstore.checkout.previewing.tr(context: context),
                  style: TextStyle(fontSize: 13.sp, color: theme.hintColor),
                ),
              ],
            )
          : hasError
              ? Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red, size: 18.sp),
                    8.horizontalSpace,
                    Expanded(child: Text(previewError!, style: TextStyle(fontSize: 12.sp, color: Colors.red.shade700))),
                  ],
                )
              : hasDiscount
                  ? Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(Icons.local_offer_rounded, color: Colors.green, size: 16.sp),
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.webstore.checkout.expected_discount.tr(context: context),
                                style: TextStyle(fontSize: 11.sp, color: theme.hintColor),
                              ),
                              Text(
                                '-${previewDiscount!.toStringAsFixed(2)} ${AppConstants.currency}',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: Colors.green.shade700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
    );
  }
}
