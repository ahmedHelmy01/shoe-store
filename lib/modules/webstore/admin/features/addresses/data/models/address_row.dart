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
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      if (value is num) return value.toInt();
      return null;
    }

    return AddressRow(
      id: parseInt(json['id']) ?? 0,
      name: json['name'] as String? ?? 'Home',
      mobile: json['mobile'] as String?,
      governorateId: parseInt(json['governorate_id']),
      cityId: parseInt(json['city_id']),
      addressDetails: json['address_details'] as String?,
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
      isDefault: json['is_default'] is bool 
          ? json['is_default'] as bool 
          : (parseInt(json['is_default']) ?? 0) == 1,
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
