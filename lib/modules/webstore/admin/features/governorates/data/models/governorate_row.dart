class GovernorateRow {
  final int id;
  final int countryId;
  final String name;
  final String? nameEn;
  final String? nameAr;
  final bool isActive;
  final String? countryName;

  const GovernorateRow({
    required this.id,
    required this.countryId,
    required this.name,
    this.nameEn,
    this.nameAr,
    required this.isActive,
    this.countryName,
  });

  factory GovernorateRow.fromJson(Map<String, dynamic> json) {
    final country = json['country'] as Map?;
    return GovernorateRow(
      id: json['id'] as int? ?? 0,
      countryId: json['country_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      countryName: country?['name'] as String?,
    );
  }
}
