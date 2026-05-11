/// Store Settings Model
///
/// Contains global store configuration such as logos, social media links, 
/// and contact details for the storefront.
class StoreSettingsModel {
  final String? logo;
  final String? logoDark;
  final String? shippingValue;
  final String? address;
  final String? addressAr;
  final String? mobile;
  final String? email;
  final String? facebook;
  final String? twitter;
  final String? instagram;
  final String? telegram;

  StoreSettingsModel({
    this.logo,
    this.logoDark,
    this.shippingValue,
    this.address,
    this.addressAr,
    this.mobile,
    this.email,
    this.facebook,
    this.twitter,
    this.instagram,
    this.telegram,
  });

  factory StoreSettingsModel.fromJson(Map<String, dynamic> json) {
    return StoreSettingsModel(
      logo: json['logo'] as String?,
      logoDark: json['logo_dark'] as String?,
      shippingValue: json['shipping_value'] as String?,
      address: json['address'] as String?,
      addressAr: json['address_ar'] as String?,
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
      facebook: json['facebook'] as String?,
      twitter: json['twitter'] as String?,
      instagram: json['instagram'] as String?,
      telegram: json['telegram'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logo': logo,
      'logo_dark': logoDark,
      'shipping_value': shippingValue,
      'address': address,
      'address_ar': addressAr,
      'mobile': mobile,
      'email': email,
      'facebook': facebook,
      'twitter': twitter,
      'instagram': instagram,
      'telegram': telegram,
    };
  }
}
