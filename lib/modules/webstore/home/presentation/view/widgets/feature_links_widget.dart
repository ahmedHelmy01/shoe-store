import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/modules/webstore/branches/presentation/view/branches_map_view.dart';
import 'feature_item_data.dart';
import 'feature_item_card.dart';

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
            onTap: () => _handleFeatureTap(context, feature),
          );
        },
      ),
    );
  }

  void _handleFeatureTap(BuildContext context, FeatureItemData feature) {
    switch (feature.type) {
      case FeatureType.ourBranches:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const BranchesMapView()),
        );
        break;
      case FeatureType.exclusiveOffers:
      case FeatureType.bestSellers:
      case FeatureType.shopNow:
        final preset = switch (feature.type) {
          FeatureType.exclusiveOffers => 'exclusive',
          FeatureType.bestSellers => 'best_seller',
          _ => 'shop_now',
        };
        AppNavigator.push(
          context,
          AppRouteNames.webstoreCatalogProducts,
          arguments: {'preset': preset},
        );
        break;
    }
  }
}
