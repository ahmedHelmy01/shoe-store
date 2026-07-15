import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';

class PointsRedemptionSectionPointsSelector extends StatelessWidget {
  final int selectedPoints;
  final int maxPoints;
  final ValueChanged<double> onSliderChanged;
  final ValueChanged<double> onQuickSelect;

  const PointsRedemptionSectionPointsSelector({
    super.key,
    required this.selectedPoints,
    required this.maxPoints,
    required this.onSliderChanged,
    required this.onQuickSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.webstore.checkout.points_used_label.tr(context: context),
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '$selectedPoints',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
            ),
          ],
        ),
        8.verticalSpace,
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.primary.withValues(alpha: 0.15),
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.1),
            trackHeight: 6.h,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.r),
            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: AppColors.primary,
            valueIndicatorTextStyle: TextStyle(color: Colors.white, fontSize: 11.sp),
          ),
          child: Slider(
            value: selectedPoints.clamp(0, maxPoints.toDouble()).toDouble(),
            min: 0,
            max: maxPoints.toDouble(),
            divisions: maxPoints > 200 ? (maxPoints / 10).round() : maxPoints,
            label: LocaleKeys.webstore.checkout.points_unit.tr(
              context: context,
              args: [selectedPoints.toString()],
            ),
            onChanged: onSliderChanged,
          ),
        ),
        4.verticalSpace,
        Row(
          children: [
            Text('0', style: TextStyle(fontSize: 11.sp, color: theme.hintColor)),
            const Spacer(),
            Text('$maxPoints', style: TextStyle(fontSize: 11.sp, color: theme.hintColor)),
          ],
        ),
        12.verticalSpace,
        Row(
          children: [
            _quickBtn('25%', 0.25, selectedPoints, theme),
            8.horizontalSpace,
            _quickBtn('50%', 0.50, selectedPoints, theme),
            8.horizontalSpace,
            _quickBtn('75%', 0.75, selectedPoints, theme),
            8.horizontalSpace,
            _quickBtn(
              LocaleKeys.webstore.checkout.all_points.tr(context: context),
              1.0,
              selectedPoints,
              theme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _quickBtn(String label, double fraction, int selectedPoints, ThemeData theme) {
    final pts = (maxPoints * fraction).round().clamp(0, maxPoints);
    final isSelected = selectedPoints == pts && selectedPoints > 0;
    return Expanded(
      child: OutlinedButton(
        onPressed: () => onQuickSelect(fraction),
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
          foregroundColor: isSelected ? AppColors.primary : null,
          side: BorderSide(color: isSelected ? AppColors.primary : theme.dividerColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          padding: EdgeInsets.symmetric(vertical: 10.h),
        ),
        child: Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
