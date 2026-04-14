class BranchRow {
  final int id;
  final String name;
  final String? nameAr;
  final String? code;
  final String? phone;
  final String? email;
  final String? address;
  final String? addressAr;
  final double? latitude;
  final double? longitude;
  final bool isActive;

  const BranchRow({
    required this.id,
    required this.name,
    this.nameAr,
    this.code,
    this.phone,
    this.email,
    this.address,
    this.addressAr,
    this.latitude,
    this.longitude,
    required this.isActive,
  });

  String? get location => address;

  factory BranchRow.fromJson(Map<String, dynamic> json) {
    return BranchRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      code: json['code'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      addressAr: json['address_ar'] as String?,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim());
    return null;
  }
}
