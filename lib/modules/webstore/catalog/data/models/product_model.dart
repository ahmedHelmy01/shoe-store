/// WebStore Product Model
///
/// Representative of a sellable item in the WebStore module.
library;

import 'package:erp/core/common_model/base_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/category_model.dart';

class WebStoreProduct extends BaseEntity with JsonSerializable {
  final String name;
  final String? slug;
  final String? description;
  final double price;
  final double? oldPrice;
  final double? discount;
  final int? stock;
  final String? image;
  final List<String>? images;
  final WebStoreCategory? category;
  final String? brand;
  final double? rating;
  final int? reviewsCount;
  final bool? isFeatured;
  final bool? isNew;
  final Map<String, dynamic>? attributes;

  const WebStoreProduct({
    super.id,
    required this.name,
    this.slug,
    this.description,
    required this.price,
    this.oldPrice,
    this.discount,
    this.stock,
    this.image,
    this.images,
    this.category,
    this.brand,
    this.rating,
    this.reviewsCount,
    this.isFeatured,
    this.isNew,
    this.attributes,
    super.createdAt,
    super.updatedAt,
  });

  factory WebStoreProduct.fromJson(Map<String, dynamic> json) {
    return WebStoreProduct(
      id: json['id'],
      name: json['name'] ?? json['title'] ?? 'بدون اسم',
      slug: json['slug'],
      description: json['description'],
      price: (json['price'] ?? 0.0).toDouble(),
      oldPrice: (json['old_price'] ?? json['compare_at_price'])?.toDouble(),
      discount: (json['discount'])?.toDouble(),
      stock: json['stock'] ?? json['quantity'],
      image: json['image'] ?? json['thumb'] ?? json['main_image'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      category: json['category'] != null ? WebStoreCategory.fromJson(json['category']) : null,
      brand: json['brand']?['name'] ?? json['brand_name'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewsCount: json['reviews_count'],
      isFeatured: json['is_featured'] ?? false,
      isNew: json['is_new'] ?? false,
      attributes: json['attributes'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'old_price': oldPrice,
    'stock': stock,
    'image': image,
    'category_id': category?.id,
  };

  bool get hasDiscount => oldPrice != null && oldPrice! > price;
  double get discountPercent => hasDiscount ? ((oldPrice! - price) / oldPrice!) * 100 : 0.0;
  bool get isInStock => (stock ?? 0) > 0;
}
