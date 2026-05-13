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
    return StoreCouponModel(
      id: json['id'],
      code: json['code'] ?? '',
      discountType: json['discount_type'] ?? '',
      discountTypeLabel: json['discount_type_label'] ?? '',
      discountValue: (json['discount_value'] ?? 0).toDouble(),
      minimumOrderValue: json['minimum_order_value'] != null
          ? (json['minimum_order_value'] as num).toDouble()
          : null,
      image: json['image'],
      imageUrl: json['image_url'],
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      isActive: json['is_active'] ?? true,
      usageLimit: json['usage_limit'],
      perUserLimit: json['per_user_limit'],
      timesUsed: json['times_used'],
      note: json['note'],
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
      return 'خصم بقيمة ${discountValue.toStringAsFixed(0)} ج.م';
    } else {
      return 'خصم بقيمة ${discountValue.toStringAsFixed(0)}%';
    }
  }

  String get valueLabel {
    if (discountType == 'fixed') {
      return '${discountValue.toStringAsFixed(0)} LE';
    } else {
      return '${discountValue.toStringAsFixed(0)}%';
    }
  }
}
