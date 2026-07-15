import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';

class PointsRedemptionSectionHeader extends StatelessWidget {
  final bool loading;
  const PointsRedemptionSectionHeader({super.key, this.loading = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(Icons.redeem_rounded, color: AppColors.primary, size: 20.sp),
        ),
        12.horizontalSpace,
        Text(
          LocaleKeys.webstore.home.my_points.tr(context: context),
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
        ),
        if (loading) ...[
          8.horizontalSpace,
          SizedBox(
            width: 14.w, height: 14.w,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
          ),
        ],
      ],
    );
  }
}
