class WarehouseRow {
  final int id;
  final String name;
  final String? nameAr;
  final String? code;
  final int? branchId;
  final String? type;
  final String? location;
  final String? phone;
  final bool isActive;

  const WarehouseRow({
    required this.id,
    required this.name,
    this.nameAr,
    this.code,
    this.branchId,
    this.type,
    this.location,
    this.phone,
    required this.isActive,
  });

  factory WarehouseRow.fromJson(Map<String, dynamic> json) {
    return WarehouseRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      code: json['code'] as String?,
      branchId: json['branch_id'] as int?,
      type: json['type'] as String?,
      location: (json['address'] ?? json['location']) as String?,
      phone: json['phone'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
