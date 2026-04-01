class AssetsConfig {
  final String assetsBase;
  final String appLogo;
  final String splashLogo;
  final String appIcon;
  final String notificationIcon;
  final String splashBackground;
  final String placeholderImage;
  final String noDataImage;
  final String errorImage;
  final String? loadingAnimation;
  final String? successAnimation;
  final String? errorAnimation;
  final String? primaryFont;

  const AssetsConfig({
    required this.assetsBase,
    required this.appLogo,
    required this.splashLogo,
    required this.appIcon,
    required this.notificationIcon,
    required this.splashBackground,
    required this.placeholderImage,
    required this.noDataImage,
    required this.errorImage,
    this.loadingAnimation,
    this.successAnimation,
    this.errorAnimation,
    this.primaryFont,
  });

  factory AssetsConfig.fromJson(Map<String, dynamic> json) => AssetsConfig(
    assetsBase: json['assetsBase'] ?? '',
    appLogo: json['appLogo'] ?? '',
    splashLogo: json['splashLogo'] ?? '',
    appIcon: json['appIcon'] ?? '',
    notificationIcon: json['notificationIcon'] ?? '',
    splashBackground: json['splashBackground'] ?? '',
    placeholderImage: json['placeholderImage'] ?? '',
    noDataImage: json['noDataImage'] ?? '',
    errorImage: json['errorImage'] ?? '',
    loadingAnimation: json['loadingAnimation'],
    successAnimation: json['successAnimation'],
    errorAnimation: json['errorAnimation'],
    primaryFont: json['primaryFont'] ?? "Tajawal",
  );

}
