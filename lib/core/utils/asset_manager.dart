/// AssetManager
/// Instead of hardcoding asset paths, this class provides a centralized way
/// to access assets across the application.
class AssetManager {
  static const String _images = "assets/images/";

  // ---------------- Images ----------------
  static String get logo => "${_images}logo.png";
  static String get noData => "${_images}no-data.png";
  static String get report3d => "${_images}3d-report.png";
  static String get chat3d => "${_images}chat.png";
  static String get supplies3d => "${_images}office-supplies.png";
  static String get info3d => "${_images}information.png";
  static String get onboardingStudy => "${_images}onboarding_study.png";
  static String get homeBanner => "${_images}home_banner.png";
}
