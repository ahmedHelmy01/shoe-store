import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'feature_item_data.dart';

/// A single circular icon card for a feature link on the home screen.
class FeatureItemCard extends StatelessWidget {
  final FeatureItemData feature;
  final VoidCallback? onTap;

  const FeatureItemCard({
    super.key,
    required this.feature,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: isDark ? theme.cardColor : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.2)
                      : Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: feature.iconPath != null
                  ? AppImage(
                      imagePath: feature.iconPath!,
                      width: 48.w,
                      height: 48.w,
                      fit: BoxFit.contain,
                    )
                  : Text(
                      feature.icon,
                      style: TextStyle(fontSize: 32.sp),
                    ),
            ),
          ),
          8.verticalSpace,
          Text(
            feature.title(context),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
