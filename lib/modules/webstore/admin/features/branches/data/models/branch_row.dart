class BranchRow {
  final int id;
  final String name;
  final String? nameAr;
  final String? phone;
  final String? address;
  final bool isActive;

  const BranchRow({
    required this.id,
    required this.name,
    this.nameAr,
    this.phone,
    this.address,
    required this.isActive,
  });

  String? get location => address;

  factory BranchRow.fromJson(Map<String, dynamic> json) {
    return BranchRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
