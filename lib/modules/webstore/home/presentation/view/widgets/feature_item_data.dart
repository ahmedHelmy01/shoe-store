import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/utils/asset_manager.dart';
import 'package:flutter/material.dart';

enum FeatureType {
  exclusiveOffers,
  shopNow,
  ourBranches,
}

/// Data model for a single feature link item on the home screen.
class FeatureItemData {
  final FeatureType type;
  final String icon;
  final String? iconPath;

  const FeatureItemData({
    required this.type,
    required this.icon,
    this.iconPath,
  });

  String title(BuildContext context) {
    final keys = LocaleKeys.webstore.home;
    return switch (type) {
      FeatureType.exclusiveOffers =>
        keys.exclusive_offers.tr(context: context),
      FeatureType.shopNow => keys.shop_now.tr(context: context),
      FeatureType.ourBranches => keys.our_branches.tr(context: context),
    };
  }

  /// Pre-defined list of feature links displayed on the home screen.
  static final List<FeatureItemData> all = [
    FeatureItemData(
      type: FeatureType.exclusiveOffers,
      icon: '🎁',
      iconPath: AssetManager.specialTag,
    ),
    FeatureItemData(
      type: FeatureType.shopNow,
      icon: '🛒',
      iconPath: AssetManager.shopping,
    ),
    FeatureItemData(
      type: FeatureType.ourBranches,
      icon: '📍',
      iconPath: AssetManager.information,
    ),
  ];
}
