import 'package:erp/core/network/network_url.dart';

class CategoryRow {
  final int id;
  final String name;
  final String? nameEn;
  final String? nameAr;
  final String? code;
  final int? parentId;
  final String? description;
  final String? descriptionEn;
  final String? descriptionAr;
  final String? image;
  final String? imageUrl;
  final bool isActive;
  final bool hasChildren;

  CategoryRow({
    required this.id,
    required this.name,
    this.nameEn,
    this.nameAr,
    this.code,
    this.parentId,
    this.description,
    this.descriptionEn,
    this.descriptionAr,
    this.image,
    this.imageUrl,
    this.isActive = true,
    this.hasChildren = false,
  });

  factory CategoryRow.fromJson(Map<String, dynamic> json) {
    final imagePath = json['image'] as String?;
    final providedUrl = json['image_url'] as String?;

    return CategoryRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? json['name_en'] as String? ?? 'Unnamed Category',
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
      code: json['code'] as String?,
      parentId: json['parent_id'] as int?,
      description: json['description'] as String? ?? json['description_en'] as String?,
      descriptionEn: json['description_en'] as String?,
      descriptionAr: json['description_ar'] as String?,
      image: imagePath,
      imageUrl: (providedUrl != null && providedUrl.isNotEmpty)
          ? providedUrl
          : (imagePath != null ? NetworkUrl.imageUrl(imagePath) : null),
      isActive: (json['active'] ?? json['is_active'] ?? true) as bool,
      hasChildren: json['has_children'] == true || json['has_children'] == 1,
    );
  }
}
