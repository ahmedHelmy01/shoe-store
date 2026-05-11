/// AssetManager
/// Instead of hardcoding asset paths, this class provides a centralized way
/// to access assets across the application.
class AssetManager {
  static const String _images = "assets/common/images/";
  static const String _webstoreImages = "assets/webstore/images/";

  // ---------------- General Images ----------------
  static String get logo => "${_images}logo.png";
  static String get noData => "${_webstoreImages}no-data-6.png";
  static String get report3d => "${_images}3d-report.png";
  static String get chat3d => "${_images}chat.png";
  static String get supplies3d => "${_images}office-supplies.png";
  static String get info3d => "${_images}information.png";
  static String get onboardingStudy => "${_images}onboarding_study.png";
  static String get homeBanner => "${_images}home_banner.png";

  // ---------------- WebStore Pharmacy Images ----------------
  static String get pharmacyLogo => "${_webstoreImages}logo.png";
  static String get logoElTarshopy =>
      "${_webstoreImages}WhatsApp_Image_2025-12-25_at_17.23.37-removebg-preview.png";

  static String get drugs => "${_webstoreImages}drugs.png";
  static String get syringe => "${_webstoreImages}syringe.png";
  static String get discount => "${_webstoreImages}discount.png";
  static String get bestSeller => "${_webstoreImages}best-seller.png";
  static String get bestSale => "${_webstoreImages}bestsale.png";
  static String get splashTarshouby => "${_webstoreImages}splash_tarshouby.png";
  static String get done => "${_webstoreImages}done.png";
  static String get face => "${_webstoreImages}face.png";
  static String get car => "${_webstoreImages}car.png";
  static String get medicine => "${_webstoreImages}medicine.png";
  static String get medicalServices => "${_webstoreImages}medical-services.png";
  static String get information => "${_images}information.png";

  // Icons/Labels
  static String get camera => "${_webstoreImages}camera.png";
  static String get shopping => "${_webstoreImages}shopping.png";
  static String get specialTag => "${_webstoreImages}special-tag.png";

  // Admin State Illustrations
  static String get adminError => "${_webstoreImages}admin_error.png";
  static String get adminUnauthorized => "${_webstoreImages}admin_unauthorized.png";

  // Payment Methods
  static String get visa => "${_webstoreImages}visa.png";
  static String get instapay => "${_webstoreImages}instapay.png";
  static String get vodafoneCash => "${_webstoreImages}vodafoneCash.png";
}
