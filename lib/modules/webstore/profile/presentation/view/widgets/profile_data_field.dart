import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/constants/app_constants.dart';

class ProfileDataField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool isEditing;
  final bool isLast;

  const ProfileDataField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    required this.isEditing,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        if (isEditing)
          Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
            child: AppTextField(
              controller: controller,
              label: label,
              prefixIcon: Icon(icon, color: AppColors.primaryOrange, size: 20.sp),
              borderRadius: 12.r,
            ),
          )
        else
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: AppColors.primaryOrange, size: 18.sp),
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(fontSize: 12.sp, color: theme.hintColor)),
                    Text(controller.text, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        if (!isEditing && !isLast)
          Divider(height: 24.h, thickness: 0.5, color: theme.dividerColor.withValues(alpha: 0.5)),
      ],
    );
  }
}
