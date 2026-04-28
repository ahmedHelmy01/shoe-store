class CustomerGroupRow {
  final int id;
  final String title;
  final String? titleAr;
  final int? parentId;
  final bool isDefault;
  final bool isActive;
  final int? companyId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CustomerGroupRow({
    required this.id,
    required this.title,
    this.titleAr,
    this.parentId,
    required this.isDefault,
    required this.isActive,
    this.companyId,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerGroupRow.fromJson(Map<String, dynamic> json) {
    return CustomerGroupRow(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String?,
      parentId: json['parent_id'] as int?,
      isDefault: json['is_default'] == true || json['is_default'] == 1,
      isActive: json['is_active'] == true || json['is_active'] == 1 || json['is_active'] == null,
      companyId: json['company_id'] as int?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }
}
