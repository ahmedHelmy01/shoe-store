class WarehouseRow {
  final int id;
  final String name;
  final String? nameAr;
  final String? location;
  final bool isActive;

  const WarehouseRow({
    required this.id,
    required this.name,
    this.nameAr,
    this.location,
    required this.isActive,
  });

  factory WarehouseRow.fromJson(Map<String, dynamic> json) {
    return WarehouseRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      location: json['location'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
