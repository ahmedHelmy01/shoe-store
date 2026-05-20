import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/network/network_url.dart';

class PrescriptionImageViewer extends StatelessWidget {
  final int prescriptionId;
  final String imagePath;
  final bool isDark;

  const PrescriptionImageViewer({
    super.key,
    required this.prescriptionId,
    required this.imagePath,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AppAnimation.fadeZoomIn(
      duration: const Duration(milliseconds: 500),
      child: Container(
        height: 320.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Hero(
                    tag: 'prescription_img_$prescriptionId',
                    child: AppImage(
                      imagePath: NetworkUrl.fullUrl(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Zoom Instruction overlay
              Positioned(
                bottom: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.zoom_in_rounded, color: Colors.white, size: 14.sp),
                      6.horizontalSpace,
                      Text(
                        LocaleKeys.webstore.prescriptions.pinch_to_zoom.tr(context: context),
                        style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
