/// AssetManager
/// Instead of hardcoding asset paths, this class provides a centralized way
/// to access assets across the application.
class AssetManager {
  static const String _images = "assets/images/";
  static const String _webstoreImages = "assets/webstore/images/";

  // ---------------- General Images ----------------
  static String get logo => "${_images}logo.png";
  static String get noData => "${_images}no-data.png";
  static String get report3d => "${_images}3d-report.png";
  static String get chat3d => "${_images}chat.png";
  static String get supplies3d => "${_images}office-supplies.png";
  static String get info3d => "${_images}information.png";
  static String get onboardingStudy => "${_images}onboarding_study.png";
  static String get homeBanner => "${_images}home_banner.png";

  // ---------------- WebStore Pharmacy Images ----------------
  static String get pharmacyLogo => "${_webstoreImages}logo.png";
  static String get drugs => "${_webstoreImages}drugs.png";
  static String get medicine => "${_webstoreImages}medicine.png";
  static String get syringe => "${_webstoreImages}syringe.png";
  static String get discount => "${_webstoreImages}discount.png";
  static String get bestSeller => "${_webstoreImages}best-seller.png";
  static String get bestSale => "${_webstoreImages}bestsale.png";
  static String get promotionCard => "${_webstoreImages}promotion_card.png";
  static String get splashTarshouby => "${_webstoreImages}splash_tarshouby.png";
  static String get frameTarshoby => "${_webstoreImages}frametarshoby.png";
  static String get done => "${_webstoreImages}done.png";
  static String get face => "${_webstoreImages}face.png";
  static String get sale => "${_webstoreImages}sale.png";
  static String get car => "${_webstoreImages}car.png";
  
  // Icons/Labels
  static String get ratingLabel => "${_webstoreImages}rating_label.png";
  static String get camera => "${_webstoreImages}camera.png";
  static String get shopping => "${_webstoreImages}shopping.png";
  static String get specialTag => "${_webstoreImages}special-tag.png";
  
  // Payment Methods
  static String get visa => "${_webstoreImages}visa.png";
  static String get instapay => "${_webstoreImages}instapay.png";
  static String get vodafoneCash => "${_webstoreImages}vodafoneCash.png";
}
