import 'package:erp/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NearestBranchesLoadingCard extends StatelessWidget {
  const NearestBranchesLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      color: isDark ? const Color(0xFF0F172A) : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            SizedBox(
              width: 18.w,
              height: 18.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation(AppColors.primaryOrange),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Text(
                'جارٍ تحديد أقرب الفروع...',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
