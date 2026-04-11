class CouponRow {
  final int id;
  final String code;
  final String type;
  final double value;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final int? usageLimit;
  final int usageCount;
  final bool isActive;

  const CouponRow({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    this.startsAt,
    this.expiresAt,
    this.usageLimit,
    required this.usageCount,
    required this.isActive,
  });

  factory CouponRow.fromJson(Map<String, dynamic> json) {
    return CouponRow(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      type: json['type'] as String? ?? 'fixed',
      value: (json['value'] as num? ?? 0).toDouble(),
      startsAt: json['starts_at'] != null ? DateTime.tryParse(json['starts_at']) : null,
      expiresAt: json['expires_at'] != null ? DateTime.tryParse(json['expires_at']) : null,
      usageLimit: json['usage_limit'] as int?,
      usageCount: json['usage_count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
