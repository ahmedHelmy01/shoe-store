import 'package:erp/core/common_model/base_model.dart';
import 'package:erp/core/network/network_url.dart';

class ManufacturerModel extends BaseEntity with JsonSerializable {
  final String name;
  final String? nameEn;
  final String? nameAr;
  final String? description;
  final String? descriptionAr;
  final String? logo;
  final bool isActive;

  const ManufacturerModel({
    super.id,
    required this.name,
    this.nameEn,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.logo,
    this.isActive = true,
    super.createdAt,
    super.updatedAt,
  });

  factory ManufacturerModel.fromJson(Map<String, dynamic> json) {
    final logoPath = json['logo'] as String?;

    return ManufacturerModel(
      id: json['id'],
      name: json['name'] ?? '',
      nameEn: json['name_en'],
      logo: logoPath != null && logoPath.isNotEmpty ? NetworkUrl.imageUrl(logoPath) : null,
      nameAr: json['name_ar'],
      description: json['description_en'] as String? ?? json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
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
    'description': description,
    'description_ar': descriptionAr,
    'logo': logo,
    'is_active': isActive,
  };
}
