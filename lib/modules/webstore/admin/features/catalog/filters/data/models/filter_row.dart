class FilterRow {
  final int id;
  final String name;
  final String? nameAr;
  final bool isActive;

  const FilterRow({
    required this.id,
    required this.name,
    this.nameAr,
    required this.isActive,
  });

  factory FilterRow.fromJson(Map<String, dynamic> json) {
    return FilterRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? json['name_en'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      isActive: (json['active'] ?? json['is_active'] ?? true) as bool,
    );
  }
}
