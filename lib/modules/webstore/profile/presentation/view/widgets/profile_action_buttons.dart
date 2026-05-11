import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileActionButtons extends StatelessWidget {
  final bool isEditing;
  final bool isLoading;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  const ProfileActionButtons({
    super.key,
    required this.isEditing,
    required this.isLoading,
    required this.onSave,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        if (isEditing)
          AppAnimation.fadeInUp(
            child: AppButton(
              onPressed: onSave,
              isLoading: isLoading,
              isGradient: true,
              child: Text(
                LocaleKeys.webstore.profile.save_changes.tr(context: context),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          )
        else
          AppAnimation.fadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Container(
              margin: EdgeInsets.only(top: 20.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.red.withValues(alpha: 0.1), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20.sp),
                      ),
                      12.horizontalSpace,
                      Text(
                        LocaleKeys.webstore.profile.delete_account.tr(context: context),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  12.verticalSpace,
                  Text(
                    LocaleKeys.webstore.profile.delete_confirm.tr(context: context),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: theme.hintColor,
                      height: 1.4,
                    ),
                  ),
                  16.verticalSpace,
                  InkWell(
                    onTap: onDelete,
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text(
                          LocaleKeys.webstore.profile.delete_button.tr(context: context),
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        40.verticalSpace,
      ],
    );
  }
}
