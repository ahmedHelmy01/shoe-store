class CountryRow {
  final int id;
  final String name;
  final String? nameAr;
  final String? code;
  final String? phoneCode;
  final bool isActive;

  const CountryRow({
    required this.id,
    required this.name,
    this.nameAr,
    this.code,
    this.phoneCode,
    this.isActive = true,
  });

  factory CountryRow.fromJson(Map<String, dynamic> json) {
    return CountryRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      code: json['code'] as String?,
      phoneCode: json['phone_code'] as String?,
      isActive: (json['is_active'] ?? true) as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'code': code,
      'phone_code': phoneCode,
      'is_active': isActive,
    };
  }
}
