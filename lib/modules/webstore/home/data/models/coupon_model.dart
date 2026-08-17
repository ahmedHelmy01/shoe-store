import 'package:erp/core/network/network_url.dart';
import 'package:erp/core/constants/app_constants.dart';

class StoreCouponModel {
  final int? id;
  final String code;
  final String discountType;
  final String discountTypeLabel;
  final double discountValue;
  final double? minimumOrderValue;
  final String? image;
  final String? imageUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final int? usageLimit;
  final int? perUserLimit;
  final int? timesUsed;
  final String? note;

  StoreCouponModel({
    this.id,
    required this.code,
    required this.discountType,
    required this.discountTypeLabel,
    required this.discountValue,
    this.minimumOrderValue,
    this.image,
    this.imageUrl,
    this.startDate,
    this.endDate,
    this.isActive = true,
    this.usageLimit,
    this.perUserLimit,
    this.timesUsed,
    this.note,
  });

  factory StoreCouponModel.fromJson(Map<String, dynamic> json) {
    final rawType = json['discount_type'];
    String typeStr = 'percentage';
    if (rawType == 2 ||
        rawType?.toString() == '2' ||
        json['discount_type_label']?.toString().toLowerCase().contains('fixed') == true ||
        json['discount_type']?.toString().toLowerCase() == 'fixed') {
      typeStr = 'fixed';
    }

    final rawImage = json['image']?.toString();
    final rawImageUrl = json['image_url']?.toString();

    return StoreCouponModel(
      id: json['id'] != null ? _parseInt(json['id']) : null,
      code: json['code']?.toString() ?? '',
      discountType: typeStr,
      discountTypeLabel: json['discount_type_label']?.toString() ?? '',
      discountValue: _parseDouble(json['discount_value']),
      minimumOrderValue: json['minimum_order_value'] != null
          ? _parseDouble(json['minimum_order_value'])
          : null,
      image: rawImage != null ? NetworkUrl.imageUrl(rawImage) : null,
      imageUrl: rawImageUrl != null ? NetworkUrl.imageUrl(rawImageUrl) : null,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'].toString())
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'].toString())
          : null,
      isActive: json['is_active'] != null ? _parseBool(json['is_active']) : true,
      usageLimit: json['usage_limit'] != null ? _parseInt(json['usage_limit']) : null,
      perUserLimit: json['per_user_limit'] != null ? _parseInt(json['per_user_limit']) : null,
      timesUsed: json['times_used'] != null ? _parseInt(json['times_used']) : null,
      note: json['note']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'discount_type': discountType,
      'discount_type_label': discountTypeLabel,
      'discount_value': discountValue,
      'minimum_order_value': minimumOrderValue,
      'image': image,
      'image_url': imageUrl,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive,
      'usage_limit': usageLimit,
      'per_user_limit': perUserLimit,
      'times_used': timesUsed,
      'note': note,
    };
  }

  String get description {
    if (discountType == 'fixed') {
      return 'خصم بقيمة ${discountValue.toStringAsFixed(0)} د.أ';
    } else {
      return 'خصم بقيمة ${discountValue.toStringAsFixed(0)}%';
    }
  }

  String get valueLabel {
    if (discountType == 'fixed') {
      return '${discountValue.toStringAsFixed(0)} ${AppConstants.currency}';
    } else {
      return '${discountValue.toStringAsFixed(0)}%';
    }
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
