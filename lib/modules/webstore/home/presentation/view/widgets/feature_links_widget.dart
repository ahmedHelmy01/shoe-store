import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/modules/webstore/home/data/models/webstore_mock_data.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';

class FeatureLinksWidget extends StatelessWidget {
  const FeatureLinksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final features = WebStoreMockData.featureLinks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
// Removed redundant title for consistency with section headers in home screen
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4.h,
              crossAxisSpacing: 0.w,
              childAspectRatio: 0.92,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return _buildFeatureItem(context, feature);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(BuildContext context, MockFeatureLink feature) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        // Navigation placeholder
      },
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
                  color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.06),
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
                  : Text(feature.icon, style: TextStyle(fontSize: 32.sp)),
            ),
          ),
          8.verticalSpace,
          Text(
            feature.title.tr(context: context),
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
