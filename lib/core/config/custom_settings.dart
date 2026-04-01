class CustomSettings {
  final bool enableGradientBackground;
  final bool extendBodyBehindAppBar;
  final bool enableTransparentAppBar;
  final bool roundedBottomNav;
  final double bottomNavRadius;
  final bool enableCustomAnimations;
  final String defaultLanguage;
  final bool rtlSupport;
  final bool enableShadows;
  final bool enableBlurEffects;
  final double contentPadding;
  final List<String>? primaryGradient;
  final List<String>? secondaryGradient;
  final bool? showPrescriptionTab;
  final bool? enableOrderTracking;

  const CustomSettings({
    this.enableGradientBackground = false,
    this.extendBodyBehindAppBar = false,
    this.enableTransparentAppBar = false,
    this.roundedBottomNav = true,
    this.bottomNavRadius = 20.0,
    this.enableCustomAnimations = false,
    this.defaultLanguage = 'ar',
    this.rtlSupport = true,
    this.enableShadows = true,
    this.enableBlurEffects = false,
    this.contentPadding = 16.0,
    this.primaryGradient,
    this.secondaryGradient,
    this.showPrescriptionTab,
    this.enableOrderTracking,
  });

  factory CustomSettings.fromJson(Map<String, dynamic> json) => CustomSettings(
    enableGradientBackground: json['enableGradientBackground'] ?? false,
    extendBodyBehindAppBar: json['extendBodyBehindAppBar'] ?? false,
    enableTransparentAppBar: json['enableTransparentAppBar'] ?? false,
    roundedBottomNav: json['roundedBottomNav'] ?? true,
    bottomNavRadius: (json['bottomNavRadius'] ?? 20).toDouble(),
    enableCustomAnimations: json['enableCustomAnimations'] ?? false,
    defaultLanguage: json['defaultLanguage'] ?? 'ar',
    rtlSupport: json['rtlSupport'] ?? true,
    enableShadows: json['enableShadows'] ?? true,
    enableBlurEffects: json['enableBlurEffects'] ?? false,
    contentPadding: (json['contentPadding'] ?? 16).toDouble(),
    primaryGradient:
    (json['primaryGradient'] as List?)?.map((e) => e.toString()).toList(),
    secondaryGradient:
    (json['secondaryGradient'] as List?)?.map((e) => e.toString()).toList(),
    showPrescriptionTab: json['showPrescriptionTab'],
    enableOrderTracking: json['enableOrderTracking'],
  );
}
