class OrderStatusRow {
  final int id;
  final String name;
  final String? nameAr;
  final String? nameEn;
  final String color;
  final int sortOrder;
  final bool isDefault;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderStatusRow({
    required this.id,
    required this.name,
    this.nameAr,
    this.nameEn,
    required this.color,
    required this.sortOrder,
    required this.isDefault,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderStatusRow.fromJson(Map<String, dynamic> json) {
    return OrderStatusRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      nameEn: json['name_en'] as String?,
      color: json['color'] as String? ?? '#000000',
      sortOrder: json['sort_order'] as int? ?? 0,
      isDefault: json['is_default'] == true || json['is_default'] == 1,
      isActive: json['is_active'] == true || json['is_active'] == 1 || json['is_active'] == null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }
}
