import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/router/route_generator.dart';
import 'feature_item_data.dart';
import 'feature_item_card.dart';
import 'branch_selection_sheet.dart';

/// Grid of quick-access feature links on the home screen.
class FeatureLinksWidget extends ConsumerWidget {
  const FeatureLinksWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final features = FeatureItemData.all;

    return Padding(
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
          return FeatureItemCard(
            feature: feature,
            onTap: () => _handleFeatureTap(context, ref, feature),
          );
        },
      ),
    );
  }

  void _handleFeatureTap(
    BuildContext context,
    WidgetRef ref,
    FeatureItemData feature,
  ) {
    switch (feature.title) {
      case 'فروعنا':
        BranchSelectionSheet.show(context, ref);
        break;
      case 'الروشتة':
        AppNavigator.push(
          context,
          AppRouteNames.webstorePage,
          arguments: {'slug': 'prescriptions', 'title': feature.title},
        );
        break;
      case 'خدمات طبية':
        AppNavigator.push(
          context,
          AppRouteNames.webstorePage,
          arguments: {'slug': 'medical-services', 'title': feature.title},
        );
        break;
      case 'عروض حصرية':
        // TODO: Navigate to catalog with offers filter
        break;
      case 'تسوق الآن':
        // TODO: Navigate to main catalog tab
        break;
    }
  }
}
