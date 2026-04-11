class PropertyRow {
  final int id;
  final String name;
  final String? nameAr;
  final String type;
  final bool isFilterable;
  final bool isActive;

  const PropertyRow({
    required this.id,
    required this.name,
    this.nameAr,
    required this.type,
    required this.isFilterable,
    required this.isActive,
  });

  factory PropertyRow.fromJson(Map<String, dynamic> json) {
    return PropertyRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      type: json['type'] as String? ?? 'text',
      isFilterable: json['is_filterable'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
