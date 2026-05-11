import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfilePointsCard extends StatelessWidget {
  final int points;

  const ProfilePointsCard({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points <= 0) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stars_rounded, color: AppColors.primaryOrange, size: 18.sp),
          8.horizontalSpace,
          Text(
            '$points ${LocaleKeys.webstore.profile.points.tr(context: context)}',
            style: TextStyle(
              color: AppColors.primaryOrange,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
