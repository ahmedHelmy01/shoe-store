class FilterRow {
  final int id;
  final String name;
  final String? nameEn;
  final String? nameAr;
  final int? parentId;
  final String? colorCode;
  final bool isActive;

  const FilterRow({
    required this.id,
    required this.name,
    this.nameEn,
    this.nameAr,
    this.parentId,
    this.colorCode,
    required this.isActive,
  });

  factory FilterRow.fromJson(Map<String, dynamic> json) {
    return FilterRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? json['name_en'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? json['name'] as String?,
      nameAr: json['name_ar'] as String?,
      parentId: json['parent_id'] as int?,
      colorCode: json['color_code'] as String?,
      isActive: (json['active'] ?? json['is_active'] ?? true) as bool,
    );
  }
}
