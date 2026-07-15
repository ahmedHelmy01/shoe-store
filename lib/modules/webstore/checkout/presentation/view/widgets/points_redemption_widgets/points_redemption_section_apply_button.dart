import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';

class PointsRedemptionSectionApplyButton extends StatelessWidget {
  final int selectedPoints;
  final bool isPreviewLoading;
  final VoidCallback onApply;

  const PointsRedemptionSectionApplyButton({
    super.key,
    required this.selectedPoints,
    required this.isPreviewLoading,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: (isPreviewLoading || selectedPoints <= 0) ? null : onApply,
        icon: Icon(Icons.check_rounded, size: 18.sp),
        label: Text(
          LocaleKeys.webstore.checkout.apply_points_btn.tr(
            context: context,
            args: [selectedPoints.toString()],
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: theme.disabledColor,
          disabledForegroundColor: Colors.white38,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          elevation: 0,
        ),
      ),
    );
  }
}
