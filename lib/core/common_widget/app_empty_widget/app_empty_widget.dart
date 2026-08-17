import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/utils/asset_manager.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';

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
    final glassSize = math.min(180.w, 180.0);
    final imageSize = math.min(120.w, 120.0);
    final iconSize = math.min(80.w, 80.0);
    final safePadding = math.min(32.w, 28.0);
    final titleSize = math.min(20.sp, 14.0);
    final subtitleSize = math.min(14.sp, 11.5);

    String resolveText(String? value, {required String fallbackKey}) {
      final v = value ?? fallbackKey;
      // Translate only if it matches our key conventions (e.g. "webstore.home.no_offers").
      final isKey = v.startsWith('common.') || v.startsWith('webstore.');
      return isKey ? v.tr(context: context) : v;
    }

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(safePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppAnimation.fadeInUp(
              duration: const Duration(milliseconds: 800),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (showGlassBackground)
                    ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: glassSize,
                          height: glassSize,
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
                      width: imageSize * 1.2,
                      height: imageSize * 1.2,
                      fit: BoxFit.contain,
                    )
                  else
                    Icon(
                      icon!,
                      size: iconSize,
                      color: isDark 
                          ? Colors.white.withValues(alpha: 0.3) 
                          : AppColors.primary.withValues(alpha: 0.5),
                    ),
                ],
              ),
            ),
            
            18.verticalSpace,

            // ─── Message ─────────────────────────────────────
            Text(
              resolveText(message, fallbackKey: LocaleKeys.common.no_data),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            
            if (subtitle != null) ...[
              8.verticalSpace,
              Text(
                resolveText(subtitle, fallbackKey: LocaleKeys.common.no_data),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: subtitleSize,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.62),
                  height: 1.4,
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
                    backgroundColor: AppColors.primaryWine,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    resolveText(actionText, fallbackKey: LocaleKeys.common.try_again),
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
      message: LocaleKeys.common.cart_empty,
      subtitle: LocaleKeys.common.cart_empty_subtitle,
      imagePath: AssetManager.shopping,
      actionText: LocaleKeys.common.browse_products,
      onAction: onAction,
    );
  }

  factory AppEmptyWidget.orders() {
    return AppEmptyWidget(
      message: LocaleKeys.common.no_orders_yet,
      subtitle: LocaleKeys.common.no_orders_yet_subtitle,
      imagePath: AssetManager.noData,
    );
  }

  factory AppEmptyWidget.search() {
    return AppEmptyWidget(
      message: LocaleKeys.common.no_results,
      subtitle: LocaleKeys.common.no_results_subtitle,
      icon: Icons.search_off_rounded,
    );
  }
}
