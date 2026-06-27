class AddressModel {
  final int? id;
  final String? name;
  final int? governorateId;
  final int? cityId;
  final String? governorateName;
  final String? cityName;
  final String? area;
  final String? block;
  final String? street;
  final String? building;
  final String? floor;
  final String? apartment;
  final String? phone;
  final String? notes;
  final bool isDefault;

  AddressModel({
    this.id,
    this.name,
    this.governorateId,
    this.cityId,
    this.governorateName,
    this.cityName,
    this.area,
    this.block,
    this.street,
    this.building,
    this.floor,
    this.apartment,
    this.phone,
    this.notes,
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    final govMap = json['governorate'] as Map?;
    final cityMap = json['city'] as Map?;

    return AddressModel(
      id: json['id'] as int?,
      name: json['name']?.toString(),
      governorateId: json['governorate_id'] as int?,
      cityId: json['city_id'] as int?,
      governorateName: govMap != null ? (govMap['name'] as String?) : (json['governorate_name'] as String?),
      cityName: cityMap != null ? (cityMap['name'] as String?) : (json['city_name'] as String?),
      area: json['area']?.toString(),
      block: json['block']?.toString(),
      street: json['street']?.toString(),
      building: json['building']?.toString(),
      floor: json['floor']?.toString(),
      apartment: json['apartment']?.toString(),
      phone: json['mobile']?.toString(),
      notes: json['notes']?.toString(),
      isDefault: json['is_default'] is bool
          ? json['is_default'] as bool
          : (json['is_default'] == 1 || json['is_default'] == '1'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null && name!.isNotEmpty) 'name': name,
      if (governorateId != null) 'governorate_id': governorateId,
      if (cityId != null) 'city_id': cityId,
      if (area != null) 'area': area,
      if (block != null) 'block': block,
      if (street != null) 'street': street,
      if (building != null) 'building': building,
      if (floor != null) 'floor': floor,
      if (apartment != null) 'apartment': apartment,
      if (phone != null) 'mobile': phone,
      if (notes != null) 'notes': notes,
      'is_default': isDefault,
    };
  }

  String get displayTitle =>
      (name != null && name!.isNotEmpty) ? name! : (area ?? 'عنوان توصيل');

  String get printableAddress {
    final parts = [
      if (area != null && area!.isNotEmpty) 'المنطقة: $area',
      if (block != null && block!.isNotEmpty) 'القطعة: $block',
      if (street != null && street!.isNotEmpty) 'الشارع: $street',
      if (building != null && building!.isNotEmpty) 'البناية: $building',
      if (floor != null && floor!.isNotEmpty) 'الدور: $floor',
      if (apartment != null && apartment!.isNotEmpty) 'الشقة: $apartment',
      if (cityName != null) cityName,
      if (governorateName != null) governorateName,
    ];
    return parts.where((p) => p != null && p.isNotEmpty).join('، ');
  }
}
