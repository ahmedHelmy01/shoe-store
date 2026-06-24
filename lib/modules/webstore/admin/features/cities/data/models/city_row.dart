class CityRow {
  final int id;
  final int governorateId;
  final String name;
  final String? nameEn;
  final String? nameAr;
  final String? code;
  final double deliveryFee;
  final bool isActive;
  final String? governorateName;

  const CityRow({
    required this.id,
    required this.governorateId,
    required this.name,
    this.nameEn,
    this.nameAr,
    this.code,
    required this.deliveryFee,
    required this.isActive,
    this.governorateName,
  });

  factory CityRow.fromJson(Map<String, dynamic> json) {
    final gov = json['governorate'] as Map?;
    
    return CityRow(
      id: json['id'] as int? ?? 0,
      governorateId: json['governorate_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
      code: json['code'] as String?,
      // The API returns 'shipping_cost' as a string/number
      deliveryFee: double.tryParse(json['shipping_cost']?.toString() ?? '0') ?? 0.0,
      isActive: json['is_active'] as bool? ?? true,
      governorateName: gov?['name'] as String?,
    );
  }
}
