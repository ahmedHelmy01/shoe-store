import 'package:erp/core/utils/asset_manager.dart';

/// Data model for a single feature link item on the home screen.
class FeatureItemData {
  final String title;
  final String icon;
  final String? iconPath;

  const FeatureItemData({
    required this.title,
    required this.icon,
    this.iconPath,
  });

  /// Pre-defined list of feature links displayed on the home screen.
  static final List<FeatureItemData> all = [
    FeatureItemData(
      title: 'عروض حصرية',
      icon: '🎁',
      iconPath: AssetManager.specialTag,
    ),
    FeatureItemData(
      title: 'الأكثر مبيعاً',
      icon: '🔥',
      iconPath: AssetManager.bestSeller,
    ),
    FeatureItemData(
      title: 'تسوق الآن',
      icon: '🛒',
      iconPath: AssetManager.shopping,
    ),
    FeatureItemData(
      title: 'الروشتة',
      icon: '📝',
      iconPath: AssetManager.medicine,
    ),
    FeatureItemData(
      title: 'خدمات طبية',
      icon: '👨‍⚕️',
      iconPath: AssetManager.medicalServices,
    ),
    FeatureItemData(
      title: 'فروعنا',
      icon: '📍',
      iconPath: AssetManager.information,
    ),
  ];
}
