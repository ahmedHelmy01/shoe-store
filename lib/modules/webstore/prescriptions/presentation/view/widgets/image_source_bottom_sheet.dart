import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';

class ImageSourceBottomSheet {
  static Future<void> show(BuildContext context, void Function(ImageSource) onSourceSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E2640) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w, height: 4.h,
                decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10.r)),
              ),
              20.verticalSpace,
              Text(
                LocaleKeys.webstore.prescriptions.select_image_source.tr(context: ctx),
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textColor),
              ),
              24.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SourceButton(
                    icon: Icons.camera_alt_rounded,
                    label: LocaleKeys.webstore.prescriptions.camera.tr(context: ctx),
                    color: AppColors.primaryOrange,
                    isDark: isDark,
                    onTap: () { Navigator.pop(ctx); onSourceSelected(ImageSource.camera); },
                  ),
                  _SourceButton(
                    icon: Icons.photo_library_rounded,
                    label: LocaleKeys.webstore.prescriptions.gallery.tr(context: ctx),
                    color: AppColors.primaryBlue,
                    isDark: isDark,
                    onTap: () { Navigator.pop(ctx); onSourceSelected(ImageSource.gallery); },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _SourceButton({required this.icon, required this.label, required this.color, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 120.w,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withValues(alpha: 0.25), width: 1.5),
        ),
        child: Column(children: [
          Icon(icon, size: 36.sp, color: color),
          12.verticalSpace,
          Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textColor)),
        ]),
      ),
    );
  }
}
