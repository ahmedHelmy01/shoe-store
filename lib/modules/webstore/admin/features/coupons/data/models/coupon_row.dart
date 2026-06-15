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
    if (rawType == 2 ||
        rawType?.toString() == '2' ||
        json['discount_type_label']?.toString().toLowerCase().contains('fixed') == true) {
      typeStr = 'fixed';
    }

    final imagePath = json['image']?.toString();
    final providedUrl = json['image_url']?.toString();

    return CouponRow(
      id: _parseInt(json['id']),
      code: json['code']?.toString() ?? '',
      discountType: typeStr,
      discountValue: _parseDouble(json['discount_value']),
      minimumOrderValue: _parseDouble(json['minimum_order_value']),
      maxUses: _parseInt(json['usage_limit']),
      maxUsesPerCustomer: _parseInt(json['per_user_limit']),
      startsAt: json['start_date']?.toString(),
      expiresAt: json['end_date']?.toString(),
      image: imagePath,
      imageUrl: (providedUrl != null && providedUrl.isNotEmpty)
          ? providedUrl
          : (imagePath != null && imagePath.isNotEmpty ? NetworkUrl.fullUrl(imagePath) : null),
      isActive: _parseBool(json['is_active']),
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

int _parseInt(dynamic value, [int defaultValue = 0]) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return double.tryParse(value.toString())?.toInt() ?? defaultValue;
}

double _parseDouble(dynamic value, [double defaultValue = 0.0]) {
  if (value == null) return defaultValue;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? defaultValue;
}

bool _parseBool(dynamic value, [bool defaultValue = false]) {
  if (value == null) return defaultValue;
  if (value is bool) return value;
  if (value is num) return value == 1;
  final str = value.toString().toLowerCase();
  return str == 'true' || str == '1';
}
