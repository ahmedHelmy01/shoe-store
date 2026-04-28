class BranchRow {
  final int id;
  final int? companyId;
  final String name;
  final String? nameAr;
  final String? code;
  final String? phone;
  final String? email;
  final String? address;
  final String? addressAr;
  final String? city;
  final String? country;
  final double? latitude;
  final double? longitude;
  final bool isActive;
  final bool isMain;
  final String? description;
  final String? descriptionAr;

  const BranchRow({
    required this.id,
    this.companyId,
    required this.name,
    this.nameAr,
    this.code,
    this.phone,
    this.email,
    this.address,
    this.addressAr,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    required this.isActive,
    this.isMain = false,
    this.description,
    this.descriptionAr,
  });

  String? get location => address;

  factory BranchRow.fromJson(Map<String, dynamic> json) {
    return BranchRow(
      id: json['id'] as int? ?? 0,
      companyId: json['company_id'] as int?,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      code: json['code'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      addressAr: json['address_ar'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      isActive: _toBool(json['is_active'], defaultValue: true),
      isMain: _toBool(json['is_main'], defaultValue: false),
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim());
    return null;
  }

  static bool _toBool(dynamic value, {bool defaultValue = false}) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    return defaultValue;
  }
}
