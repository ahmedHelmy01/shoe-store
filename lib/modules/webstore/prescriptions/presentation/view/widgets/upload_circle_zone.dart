import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'dashed_circle_painter.dart';

class UploadCircleZone extends StatelessWidget {
  final Animation<double> pulseAnimation;
  final XFile? pickedFile;
  final bool isUploading;
  final VoidCallback onTap;
  final bool isDark;

  const UploadCircleZone({
    super.key,
    required this.pulseAnimation,
    required this.pickedFile,
    required this.isUploading,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: pulseAnimation,
      child: Container(
        width: 200.w,
        height: 200.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? const Color(0xFF1E2640) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withValues(alpha: isDark ? 0.15 : 0.08),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipOval(
          child: InkWell(
            onTap: isUploading ? null : onTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 2 * math.pi),
                  duration: const Duration(seconds: 15),
                  builder: (_, value, child) => Transform.rotate(
                    angle: value,
                    child: CustomPaint(
                      size: Size(200.w, 200.w),
                      painter: DashedCirclePainter(
                        color: pickedFile != null ? AppColors.success : AppColors.primaryOrange,
                        strokeWidth: 2,
                        dashCount: 40,
                      ),
                    ),
                  ),
                ),
                if (pickedFile != null)
                  AppAnimation.fadeZoomIn(
                    duration: const Duration(milliseconds: 400),
                    child: Image.file(File(pickedFile!.path), width: 200.w, height: 200.w, fit: BoxFit.cover),
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_outlined, size: 48.sp, color: AppColors.primaryOrange),
                      8.verticalSpace,
                      Text(
                        LocaleKeys.webstore.prescriptions.tap_to_upload.tr(context: context),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white.withValues(alpha: 0.9) : AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
