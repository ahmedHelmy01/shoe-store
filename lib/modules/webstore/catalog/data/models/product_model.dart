/// WebStore Product Model
///
/// Representative of a sellable item in the WebStore module.
library;

import 'package:erp/core/common_model/base_model.dart';
import 'package:erp/core/network/network_url.dart';
import 'package:erp/modules/webstore/catalog/data/models/category_model.dart';

class WebStoreProduct extends BaseEntity with JsonSerializable {
  final String name;
  final String? code;
  final String? sku;
  final String? barcode;
  final String? slug;
  final String? description;
  final double price;
  final double? oldPrice;
  final double? discount;
  final int? stock;
  final String? image;
  final List<String>? images;
  final WebStoreCategory? category;
  final Map<String, dynamic>? manufacturer;
  final List<String>? tags;
  final String? brand;
  final double? rating;
  final int? reviewsCount;
  final bool? isFeatured;
  final bool? isNew;
  final Map<String, dynamic>? attributes;

  const WebStoreProduct({
    super.id,
    required this.name,
    this.code,
    this.sku,
    this.barcode,
    this.slug,
    this.description,
    required this.price,
    this.oldPrice,
    this.discount,
    this.stock,
    this.image,
    this.images,
    this.category,
    this.manufacturer,
    this.tags,
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
    double parsePrice(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    String? parseBrand(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is Map) return value['name']?.toString() ?? value['name_ar']?.toString();
      return null;
    }

    // Handle nested images array
    List<String> parseImages(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value.map((e) {
          if (e is String) return NetworkUrl.imageUrl(e);
          if (e is Map) return NetworkUrl.imageUrl(e['image']?.toString() ?? '');
          return '';
        }).where((element) => element.isNotEmpty).toList();
      }
      return [];
    }

    // Handle tags array
    List<String> parseTags(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value.map((e) {
          if (e is String) return e;
          if (e is Map) return e['name_ar']?.toString() ?? e['name']?.toString() ?? '';
          return '';
        }).where((e) => e.isNotEmpty).toList();
      }
      return [];
    }

    return WebStoreProduct(
      id: json['id'],
      name: json['name_ar'] ?? json['name'] ?? json['title'] ?? 'بدون اسم',
      code: json['code'],
      sku: json['sku'],
      barcode: json['barcode'],
      slug: json['slug'],
      description: json['description_ar'] ?? json['description'],
      price: parsePrice(json['sale_price'] ?? json['price']),
      oldPrice: parsePrice(json['old_price'] ?? json['compare_at_price']),
      discount: parsePrice(json['discount']),
      stock: json['available_quantity'] ?? json['stock'] ?? json['quantity'] ?? 0,
      image: NetworkUrl.imageUrl(json['image']),
      images: parseImages(json['images']),
      category: json['category'] != null ? WebStoreCategory.fromJson(json['category']) : null,
      manufacturer: json['manufacturer'] is Map<String, dynamic> ? json['manufacturer'] : null,
      tags: parseTags(json['tags']),
      brand: parseBrand(json['brand'] ?? json['brand_name']),
      rating: parsePrice(json['rating']),
      reviewsCount: json['review_count'] ?? json['reviews_count'] ?? 0,
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
    'stock': stock,
  };

  bool get hasDiscount => oldPrice != null && oldPrice! > price;
  double get discountPercent => hasDiscount ? ((oldPrice! - price) / oldPrice!) * 100 : 0.0;
  bool get isInStock => (stock ?? 0) > 0;
}
