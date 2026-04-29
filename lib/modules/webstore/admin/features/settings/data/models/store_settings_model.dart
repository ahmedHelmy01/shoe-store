class StoreSettingsModel {
  final String? logo;
  final String? mobile;
  final String? shippingValue;

  StoreSettingsModel({
    this.logo,
    this.mobile,
    this.shippingValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'store.logo': logo,
      'store.mobile': mobile,
      'store.shipping_value': shippingValue,
    };
  }

  factory StoreSettingsModel.empty() => StoreSettingsModel();
}
