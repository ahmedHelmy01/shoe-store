import 'package:erp/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DistancePill extends StatelessWidget {
  final double meters;
  final bool dense;

  const DistancePill({super.key, required this.meters, required this.dense});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final text = _distanceText(meters);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8.w : 10.w,
        vertical: dense ? 4.h : 6.h,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : AppColors.primaryWine.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.10)
              : AppColors.primaryWine.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: dense ? 11.sp : 12.sp,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : AppColors.primaryWine,
        ),
      ),
    );
  }

  String _distanceText(double meters) {
    if (meters < 1000) return '${meters.round()} م';
    return '${(meters / 1000).toStringAsFixed(1)} كم';
  }
}
