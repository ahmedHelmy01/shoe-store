import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';

class UploadNotesForm extends StatelessWidget {
  final TextEditingController controller;
  final bool isUploading;
  final bool isDark;

  const UploadNotesForm({
    super.key,
    required this.controller,
    required this.isUploading,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AppAnimation.fadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2640) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.webstore.prescriptions.additional_notes.tr(context: context),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textColor,
              ),
            ),
            12.verticalSpace,
            TextField(
              controller: controller,
              maxLines: 4,
              enabled: !isUploading,
              style: TextStyle(color: isDark ? Colors.white : AppColors.textColor),
              decoration: InputDecoration(
                hintText: LocaleKeys.webstore.prescriptions.notes_hint.tr(context: context),
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13.sp),
                filled: true,
                fillColor: isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.grey[500]?.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white10 : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.primaryOrange, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
