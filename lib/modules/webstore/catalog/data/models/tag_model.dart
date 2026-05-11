import 'package:erp/core/common_model/base_model.dart';

class TagModel extends BaseEntity with JsonSerializable {
  final String name;
  final String? nameEn;
  final String? nameAr;
  final bool isActive;

  const TagModel({
    super.id,
    required this.name,
    this.nameEn,
    this.nameAr,
    this.isActive = true,
    super.createdAt,
    super.updatedAt,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'],
      name: (json['name_ar'] ?? json['name'] ?? '').toString(),
      nameEn: json['name_en']?.toString(),
      nameAr: json['name_ar']?.toString(),
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'name_en': nameEn,
    'name_ar': nameAr,
    'is_active': isActive,
  };
}
