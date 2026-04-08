import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/utils/asset_manager.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';

class AppEmptyWidget extends StatelessWidget {
  final String? message;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData? icon;
  final String? imagePath;
  final bool showGlassBackground;

  const AppEmptyWidget({
    super.key,
    this.message,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.icon,
    this.imagePath,
    this.showGlassBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ─── Illustration with Glass Circle ────────────────
            Stack(
              alignment: Alignment.center,
              children: [
                if (showGlassBackground)
                  ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 180.w,
                        height: 180.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark 
                              ? Colors.white.withValues(alpha: 0.05) 
                              : AppColors.primary.withValues(alpha: 0.05),
                          border: Border.all(
                            color: isDark 
                                ? Colors.white.withValues(alpha: 0.1) 
                                : AppColors.primary.withValues(alpha: 0.1),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                
                if (imagePath != null || (imagePath == null && icon == null))
                  AppImage(
                    imagePath: imagePath ?? AssetManager.noData,
                    width: 140.w,
                    height: 140.w,
                    fit: BoxFit.contain,
                  )
                else
                  Icon(
                    icon!,
                    size: 80.w,
                    color: isDark 
                        ? Colors.white.withValues(alpha: 0.3) 
                        : AppColors.primary.withValues(alpha: 0.5),
                  ),
              ],
            ),
            
            32.verticalSpace,

            // ─── Message ─────────────────────────────────────
            Text(
              message ?? 'لا توجد بيانات حالياً',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.headlineSmall?.color,
              ),
            ),
            
            if (subtitle != null) ...[
              12.verticalSpace,
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
            ],

            // ─── Action Button ──────────────────────────────
            if (onAction != null && actionText != null) ...[
              32.verticalSpace,
              SizedBox(
                width: 200.w,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    actionText!,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─── Static Factory Methods ──────────────────────────────
  
  factory AppEmptyWidget.cart({VoidCallback? onAction}) {
    return AppEmptyWidget(
      message: 'سلة المشتريات فارغة',
      subtitle: 'لم تقم بإضافة أي منتجات إلى السلة بعد. ابدأ بالتسوق الآن!',
      imagePath: AssetManager.shopping,
      actionText: 'تصفح المنتجات',
      onAction: onAction,
    );
  }

  factory AppEmptyWidget.orders() {
    return AppEmptyWidget(
      message: 'لا توجد طلبات حتى الآن',
      subtitle: 'ستظهر طلباتك هنا بمجرد قيامك بعملية شراء.',
      imagePath: AssetManager.noData,
    );
  }

  factory AppEmptyWidget.search() {
    return AppEmptyWidget(
      message: 'لم يتم العثور على نتائج',
      subtitle: 'حاول البحث بكلمات مختلفة أو تحقق من التصنيفات.',
      icon: Icons.search_off_rounded,
    );
  }
}
