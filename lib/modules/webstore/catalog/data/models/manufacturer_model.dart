import 'package:erp/core/common_model/base_model.dart';

class ManufacturerModel extends BaseEntity with JsonSerializable {
  final String name;
  final String? nameEn;
  final String? nameAr;
  final String? logo;
  final bool isActive;

  const ManufacturerModel({
    super.id,
    required this.name,
    this.nameEn,
    this.nameAr,
    this.logo,
    this.isActive = true,
    super.createdAt,
    super.updatedAt,
  });

  factory ManufacturerModel.fromJson(Map<String, dynamic> json) {
    String? logoPath = json['logo'] as String?;
    
    // Ensure full URL for logo with the correct /storage/ prefix
    if (logoPath != null && logoPath.isNotEmpty && !logoPath.startsWith('http')) {
      final cleanPath = logoPath.startsWith('/') ? logoPath.substring(1) : logoPath;
      logoPath = 'https://moon-erp.elbaset.com/storage/$cleanPath';
    }

    return ManufacturerModel(
      id: json['id'],
      name: json['name'] ?? '',
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
      logo: logoPath,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'name_en': nameEn,
    'name_ar': nameAr,
    'logo': logo,
    'is_active': isActive,
  };
}
