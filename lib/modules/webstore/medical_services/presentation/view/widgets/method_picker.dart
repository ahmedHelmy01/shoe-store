import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/medical_services/data/models/medication_reminder_model.dart';

/// شبكة اختيار طريقة أخذ الجرعة (قبل/بعد الأكل، معدة فارغة، ...).
class MethodPickerSheet {
  static Future<AdministrationMethod?> show(
    BuildContext context, {
    required AdministrationMethod initial,
  }) {
    return showModalBottomSheet<AdministrationMethod>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MethodPickerSheet(initial: initial),
    );
  }
}

class _MethodPickerSheet extends StatefulWidget {
  final AdministrationMethod initial;

  const _MethodPickerSheet({required this.initial});

  @override
  State<_MethodPickerSheet> createState() => _MethodPickerSheetState();
}

class _MethodPickerSheetState extends State<_MethodPickerSheet> {
  late AdministrationMethod _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 16.h, bottom: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
          ),
          14.verticalSpace,
          Row(
            children: [
              Icon(Icons.medical_services_outlined, color: AppColors.primaryOrange, size: 22.sp),
              10.horizontalSpace,
              Text(
                'طريقة أخذ الجرعة',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textColor,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, size: 20.sp, color: isDark ? Colors.white60 : Colors.black54),
              ),
            ],
          ),
          14.verticalSpace,
          Flexible(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: AdministrationMethod.values.map((method) {
                  final selected = method == _selected;
                  return ChoiceChip(
                    avatar: Icon(
                      _iconFor(method),
                      size: 16.sp,
                      color: selected ? AppColors.primaryOrange : (isDark ? Colors.white70 : AppColors.textSecondary),
                    ),
                    label: Text(method.label),
                    selected: selected,
                    onSelected: (_) => setState(() => _selected = method),
                    selectedColor: AppColors.primaryOrange.withValues(alpha: 0.15),
                    backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
                    side: BorderSide(
                      color: selected
                          ? AppColors.primaryOrange
                          : (isDark ? Colors.white12 : Colors.grey.shade300),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    labelStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: selected ? AppColors.primaryOrange : (isDark ? Colors.white70 : AppColors.textSecondary),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          20.verticalSpace,
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, _selected),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
              ),
              icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
              label: Text(
                'تأكيد',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static IconData _iconFor(AdministrationMethod method) {
    switch (method) {
      case AdministrationMethod.beforeMeal:
        return Icons.restaurant_outlined;
      case AdministrationMethod.afterMeal:
        return Icons.restaurant;
      case AdministrationMethod.withMeal:
        return Icons.lunch_dining_outlined;
      case AdministrationMethod.emptyStomach:
        return Icons.water_drop_outlined;
      case AdministrationMethod.beforeBed:
        return Icons.bedtime_outlined;
      case AdministrationMethod.uponWaking:
        return Icons.wb_sunny_outlined;
      case AdministrationMethod.sublingual:
        return Icons.record_voice_over_outlined;
      case AdministrationMethod.oral:
        return Icons.local_drink_outlined;
      case AdministrationMethod.intramuscular:
        return Icons.vaccines_outlined;
      case AdministrationMethod.subcutaneous:
        return Icons.healing_outlined;
      case AdministrationMethod.inhalation:
        return Icons.air;
      case AdministrationMethod.topical:
        return Icons.back_hand_outlined;
      case AdministrationMethod.eyeEarDrops:
        return Icons.remove_red_eye_outlined;
      case AdministrationMethod.nasal:
        return Icons.medical_services_outlined;
      case AdministrationMethod.vaginal:
        return Icons.woman_outlined;
      case AdministrationMethod.asDirected:
        return Icons.fact_check_outlined;
    }
  }
}
