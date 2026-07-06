/// WebStore Category Model
///
/// Representative of a product category in the WebStore.
library;

import 'dart:developer' as developer;
import 'package:erp/core/common_model/base_model.dart';
import 'package:erp/core/network/network_url.dart';

class WebStoreCategory extends BaseEntity with JsonSerializable {
  final String name;
  final String? nameEn;
  final String? nameAr;
  final String? description;
  final String? image;
  final int? parentId;
  final int? productsCount;
  final bool? isActive;
  final List<WebStoreCategory> children;

  const WebStoreCategory({
    super.id,
    required this.name,
    this.nameEn,
    this.nameAr,
    this.description,
    this.image,
    this.parentId,
    this.productsCount,
    this.isActive,
    this.children = const [],
    super.createdAt,
    super.updatedAt,
  });

  factory WebStoreCategory.fromJson(Map<String, dynamic> json) {
    final rawImageUrl = json['image_url'] as String?;
    final rawImage = json['image'] as String?;
    final finalImage = (rawImageUrl?.isNotEmpty == true)
        ? rawImageUrl!
        : NetworkUrl.imageUrl(rawImage ?? '');
    developer.log('📸 WebStoreCategory.fromJson id=${json['id']} name=${json['name']} raw_image_url=$rawImageUrl raw_image=$rawImage final_image=$finalImage');
    return WebStoreCategory(
      id: json['id'],
      name: json['name'] ?? json['name_ar'] ?? json['name_en'] ?? 'بدون اسم',
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
      description: json['description'],
      image: finalImage,
      parentId: json['parent_id'],
      productsCount: json['products_count'],
      isActive: json['is_active'],
      children: (json['children'] as List?)
              ?.map((e) => WebStoreCategory.fromJson(e))
              .toList() ??
          [],
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
    'image': image,
    'parent_id': parentId,
    'is_active': isActive,
    'children': children.map((e) => e.toJson()).toList(),
  };
}
