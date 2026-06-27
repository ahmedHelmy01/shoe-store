class StoreSettingsModel {
  final String? logo;
  final String? logoDark;
  final String? shippingValue;
  final String? addressAr;
  final String? addressEn;
  final String? mobile;
  final String? email;
  final String? facebook;
  final String? twitter;
  final String? instagram;
  final String? telegram;
  final double? pointsEgpRate;

  const StoreSettingsModel({
    this.logo,
    this.logoDark,
    this.shippingValue,
    this.addressAr,
    this.addressEn,
    this.mobile,
    this.email,
    this.facebook,
    this.twitter,
    this.instagram,
    this.telegram,
    this.pointsEgpRate,
  });

  factory StoreSettingsModel.fromJson(Map<String, dynamic> json) {
    return StoreSettingsModel(
      logo: json['logo']?.toString(),
      logoDark: json['logo_dark']?.toString(),
      shippingValue: json['shipping_value']?.toString(),
      addressAr: json['address_ar']?.toString(),
      addressEn: json['address_en']?.toString(),
      mobile: json['mobile']?.toString(),
      email: json['email']?.toString(),
      facebook: json['facebook']?.toString(),
      twitter: json['twitter']?.toString(),
      instagram: json['instagram']?.toString(),
      telegram: json['telegram']?.toString(),
      pointsEgpRate: (json['points_egp_rate'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (logo != null) 'logo': logo,
      if (logoDark != null) 'logo_dark': logoDark,
      if (shippingValue != null) 'shipping_value': shippingValue,
      if (addressAr != null) 'address_ar': addressAr,
      if (addressEn != null) 'address_en': addressEn,
      if (mobile != null) 'mobile': mobile,
      if (email != null) 'email': email,
      if (facebook != null) 'facebook': facebook,
      if (twitter != null) 'twitter': twitter,
      if (instagram != null) 'instagram': instagram,
      if (telegram != null) 'telegram': telegram,
      if (pointsEgpRate != null) 'points_egp_rate': pointsEgpRate,
    };
  }

  factory StoreSettingsModel.empty() => const StoreSettingsModel();
}
