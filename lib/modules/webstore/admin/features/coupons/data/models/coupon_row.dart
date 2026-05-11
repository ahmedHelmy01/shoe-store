import 'package:erp/core/network/network_url.dart';

class CouponRow {
  final int id;
  final String code;
  final String discountType;
  final double discountValue;
  final double minimumOrderValue;
  final int maxUses;
  final int maxUsesPerCustomer;
  final String? startsAt;
  final String? expiresAt;
  final String? image;
  final String? imageUrl;
  final bool isActive;

  const CouponRow({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.minimumOrderValue,
    required this.maxUses,
    required this.maxUsesPerCustomer,
    this.startsAt,
    this.expiresAt,
    this.image,
    this.imageUrl,
    required this.isActive,
  });

  bool get isPercentage => discountType == 'percentage';

  factory CouponRow.fromJson(Map<String, dynamic> json) {
    // Map API int values to internal string constants
    final rawType = json['discount_type'];
    String typeStr = 'percentage';
    if (rawType == 2 || json['discount_type_label']?.toString().toLowerCase().contains('fixed') == true) {
      typeStr = 'fixed';
    }

    final imagePath = json['image'] as String?;
    final providedUrl = json['image_url'] as String?;

    return CouponRow(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      discountType: typeStr,
      discountValue: double.tryParse(json['discount_value']?.toString() ?? '0') ?? 0.0,
      minimumOrderValue: double.tryParse(json['minimum_order_value']?.toString() ?? '0') ?? 0.0,
      maxUses: json['usage_limit'] as int? ?? 0,
      maxUsesPerCustomer: json['per_user_limit'] as int? ?? 0,
      startsAt: json['start_date'] as String?,
      expiresAt: json['end_date'] as String?,
      image: imagePath,
      imageUrl: (providedUrl != null && providedUrl.isNotEmpty)
          ? providedUrl
          : (imagePath != null ? NetworkUrl.fullUrl(imagePath) : null),
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discount_type': discountType,
      'discount_value': discountValue,
      'minimum_order_value': minimumOrderValue,
      'max_uses': maxUses,
      'max_uses_per_customer': maxUsesPerCustomer,
      'starts_at': startsAt,
      'expires_at': expiresAt,
      'image': image,
      'is_active': isActive,
    };
  }
}
