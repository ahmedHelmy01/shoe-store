class CompanyRow {
  final int id;
  final String name;
  final String? nameAr;
  final String? logo;
  final bool isActive;

  const CompanyRow({
    required this.id,
    required this.name,
    this.nameAr,
    this.logo,
    required this.isActive,
  });

  factory CompanyRow.fromJson(Map<String, dynamic> json) {
    return CompanyRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? json['name_en'] as String? ?? 'Unknown',
      nameAr: json['name_ar'] as String?,
      logo: json['logo'] as String?,
      isActive: (json['active'] ?? json['is_active'] ?? true) as bool,
    );
  }
}


