class LoyaltySettingsModel {
  final bool enabled;
  final double earnRate;
  final double pointValue;
  final String maxUsageType;
  final double maxUsageValue;
  final double minInvoiceAmount;
  final int minPointsToUse;
  final String expiryType;
  final int expiryValue;
  final List<String> eligibleCustomerTypes;
  final List<int> excludedProductIds;
  final List<int> excludedCategoryIds;

  const LoyaltySettingsModel({
    required this.enabled,
    required this.earnRate,
    required this.pointValue,
    required this.maxUsageType,
    required this.maxUsageValue,
    required this.minInvoiceAmount,
    required this.minPointsToUse,
    required this.expiryType,
    required this.expiryValue,
    required this.eligibleCustomerTypes,
    required this.excludedProductIds,
    required this.excludedCategoryIds,
  });

  factory LoyaltySettingsModel.fromJson(Map<String, dynamic> json) {
    return LoyaltySettingsModel(
      enabled: json['enabled'] == true,
      earnRate: (json['earn_rate'] as num?)?.toDouble() ?? 0.0,
      pointValue: (json['point_value'] as num?)?.toDouble() ?? 0.0,
      maxUsageType: json['max_usage_type'] as String? ?? 'unlimited',
      maxUsageValue: (json['max_usage_value'] as num?)?.toDouble() ?? 0.0,
      minInvoiceAmount: (json['min_invoice_amount'] as num?)?.toDouble() ?? 0.0,
      minPointsToUse: json['min_points_to_use'] as int? ?? 0,
      expiryType: json['expiry_type'] as String? ?? 'never',
      expiryValue: json['expiry_value'] as int? ?? 0,
      eligibleCustomerTypes: (json['eligible_customer_types'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      excludedProductIds: (json['excluded_product_ids'] as List<dynamic>?)
              ?.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
              .toList() ??
          const [],
      excludedCategoryIds: (json['excluded_category_ids'] as List<dynamic>?)
              ?.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'earn_rate': earnRate,
      'point_value': pointValue,
      'max_usage_type': maxUsageType,
      'max_usage_value': maxUsageValue,
      'min_invoice_amount': minInvoiceAmount,
      'min_points_to_use': minPointsToUse,
      'expiry_type': expiryType,
      'expiry_value': expiryValue,
      'eligible_customer_types': eligibleCustomerTypes,
      'excluded_product_ids': excludedProductIds,
      'excluded_category_ids': excludedCategoryIds,
    };
  }

  static LoyaltySettingsModel empty() {
    return LoyaltySettingsModel(
      enabled: false,
      earnRate: 0.0,
      pointValue: 0.0,
      maxUsageType: 'unlimited',
      maxUsageValue: 0.0,
      minInvoiceAmount: 0.0,
      minPointsToUse: 0,
      expiryType: 'never',
      expiryValue: 0,
      eligibleCustomerTypes: const [],
      excludedProductIds: const [],
      excludedCategoryIds: const [],
    );
  }
}
