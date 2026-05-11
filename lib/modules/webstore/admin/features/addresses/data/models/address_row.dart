class AddressRow {
  final int id;
  final String name;
  final String? mobile;
  final int? governorateId;
  final int? cityId;
  final String? addressDetails;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  const AddressRow({
    required this.id,
    required this.name,
    this.mobile,
    this.governorateId,
    this.cityId,
    this.addressDetails,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  factory AddressRow.fromJson(Map<String, dynamic> json) {
    return AddressRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Home',
      mobile: json['mobile'] as String?,
      governorateId: json['governorate_id'] as int?,
      cityId: json['city_id'] as int?,
      addressDetails: json['address_details'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isDefault: json['is_default'] is bool 
          ? json['is_default'] as bool 
          : (json['is_default'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile': mobile,
      'governorate_id': governorateId,
      'city_id': cityId,
      'address_details': addressDetails,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault ? 1 : 0,
    };
  }
}
