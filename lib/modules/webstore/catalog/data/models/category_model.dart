/// WebStore Category Model
///
/// Representative of a product category in the WebStore.
library;

import 'package:erp/core/common_model/base_model.dart';

class WebStoreCategory extends BaseEntity with JsonSerializable {
  final String name;
  final String? description;
  final String? image;
  final int? parentId;
  final int? productsCount;
  final bool? isActive;

  const WebStoreCategory({
    super.id,
    required this.name,
    this.description,
    this.image,
    this.parentId,
    this.productsCount,
    this.isActive,
    super.createdAt,
    super.updatedAt,
  });

  factory WebStoreCategory.fromJson(Map<String, dynamic> json) {
    return WebStoreCategory(
      id: json['id'],
      name: json['name'] ?? json['title'] ?? 'بدون اسم',
      description: json['description'],
      image: json['image'] ?? json['thumb'],
      parentId: json['parent_id'],
      productsCount: json['products_count'],
      isActive: json['is_active'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image': image,
    'parent_id': parentId,
    'is_active': isActive,
  };
}
