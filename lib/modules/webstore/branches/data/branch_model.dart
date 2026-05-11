/// Branch Model
///
/// Represents a physical store location with contact and address details.
class BranchModel {
  final int id;
  final int companyId;
  final String name;
  final String nameAr;
  final String? code;
  final String? phone;
  final String? email;
  final String? address;
  final String? addressAr;
  final String? city;
  final String? country;
  final bool isActive;
  final bool isMain;
  final double? latitude;
  final double? longitude;
  final String? description;
  final String? descriptionAr;

  BranchModel({
    required this.id,
    required this.companyId,
    required this.name,
    required this.nameAr,
    this.code,
    this.phone,
    this.email,
    this.address,
    this.addressAr,
    this.city,
    this.country,
    required this.isActive,
    required this.isMain,
    this.latitude,
    this.longitude,
    this.description,
    this.descriptionAr,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] as int,
      companyId: json['company_id'] as int,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      code: json['code'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      addressAr: json['address_ar'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isMain: json['is_main'] as bool? ?? false,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'name': name,
      'name_ar': nameAr,
      'code': code,
      'phone': phone,
      'email': email,
      'address': address,
      'address_ar': addressAr,
      'city': city,
      'country': country,
      'is_active': isActive,
      'is_main': isMain,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'description_ar': descriptionAr,
    };
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
