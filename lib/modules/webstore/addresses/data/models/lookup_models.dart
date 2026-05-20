class GovernorateModel {
  final int id;
  final String name;
  final String? nameAr;

  GovernorateModel({
    required this.id,
    required this.name,
    this.nameAr,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
    );
  }
}

class CityModel {
  final int id;
  final int governorateId;
  final String name;
  final String? nameAr;

  CityModel({
    required this.id,
    required this.governorateId,
    required this.name,
    this.nameAr,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    final gov = json['governorate'] as Map<String, dynamic>?;
    return CityModel(
      id: json['id'] as int? ?? 0,
      governorateId:
          json['governorate_id'] as int? ?? gov?['id'] as int? ?? 0,
      name: json['name_ar'] as String? ?? json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
    );
  }
}
