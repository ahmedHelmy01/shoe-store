import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PointsRedemptionSectionAppliedState extends StatelessWidget {
  final int appliedPoints;
  final VoidCallback onCancel;

  const PointsRedemptionSectionAppliedState({
    super.key,
    required this.appliedPoints,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  LocaleKeys.webstore.checkout.points_applied_discount.tr(
                    context: context,
                    args: [appliedPoints.toString()],
                  ),
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.green.shade700),
                ),
              ),
            ],
          ),
        ),
        12.verticalSpace,
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onCancel,
            icon: Icon(Icons.close_rounded, size: 16.sp),
            label: Text(LocaleKeys.webstore.checkout.cancel_points_discount.tr(context: context)),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: BorderSide(color: Colors.red.shade200),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
        ),
      ],
    );
  }
}
