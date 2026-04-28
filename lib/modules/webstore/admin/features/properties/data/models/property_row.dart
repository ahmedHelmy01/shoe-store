class PropertyRow {
  final int id;
  final String title;
  final String? titleAr;
  final int? parentId;
  final bool isDefault;
  final String? propertyUrl;
  final bool isActive;
  final int? companyId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PropertyRow({
    required this.id,
    required this.title,
    this.titleAr,
    this.parentId,
    this.isDefault = false,
    this.propertyUrl,
    this.isActive = true,
    this.companyId,
    this.createdAt,
    this.updatedAt,
  });

  factory PropertyRow.fromJson(Map<String, dynamic> json) {
    return PropertyRow(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String?,
      parentId: json['parent_id'] as int?,
      isDefault: json['is_default'] == true || json['is_default'] == 1,
      propertyUrl: json['property_url'] as String?,
      isActive: json['is_active'] == true || json['is_active'] == 1,
      companyId: json['company_id'] as int?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }
}
