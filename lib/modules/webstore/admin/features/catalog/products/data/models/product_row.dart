import 'package:erp/core/network/network_url.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/data/models/filter_row.dart';
import 'package:erp/modules/webstore/admin/features/properties/data/models/property_row.dart';

class ProductRow {
  final int id;
  final int? companyId;
  final String? code;
  final String sku;
  final String name;
  final String? nameEn;
  final String? nameAr;
  final int? productCategoryId;
  final String? description;
  final String? descriptionAr;
  final String? barcode;
  final String? brand;
  final String? brandAr;
  final int? brandId;
  final int? baseUnitId;
  final String? purchasePrice;
  final String? salePrice;
  final String? minSalePrice;
  final bool isActive;
  final bool trackInventory;
  final String? image;
  final String? imageUrl;
  final List<String>? images;
  final List<String>? imageUrls;
  final String? notes;
  final String? notesAr;
  final bool hasVariants;
  final String? createdAt;
  final String? updatedAt;
  final List<FilterRow>? tags;
  final List<PropertyRow>? properties;

  ProductRow({
    required this.id,
    this.companyId,
    this.code,
    required this.sku,
    required this.name,
    this.nameEn,
    this.nameAr,
    this.productCategoryId,
    this.description,
    this.descriptionAr,
    this.barcode,
    this.brand,
    this.brandAr,
    this.brandId,
    this.baseUnitId,
    this.purchasePrice,
    this.salePrice,
    this.minSalePrice,
    this.isActive = true,
    this.trackInventory = true,
    this.image,
    this.imageUrl,
    this.images,
    this.imageUrls,
    this.notes,
    this.notesAr,
    this.hasVariants = false,
    this.createdAt,
    this.updatedAt,
    this.tags,
    this.properties,
  });

  factory ProductRow.fromJson(Map<String, dynamic> json) {
    String? normalizePath(String? p) {
      if (p == null || p.isEmpty) return p;
      if (p.startsWith('http')) {
        if (p.contains('/storage/')) {
          return p.split('/storage/').last;
        }
      }
      return p;
    }

    final imagePath = normalizePath(json['image'] as String?);
    final providedUrl = json['image_url'] as String?;
    
    final galleryPaths = <String>[];
    final galleryUrls = <String>[];
    
    if (json['images'] is List) {
      for (final e in json['images'] as List) {
        String? path;
        String? url;

        if (e is Map) {
          path = normalizePath(e['image'] as String?);
          url = e['image_url'] as String?;
        } else if (e is String) {
          path = normalizePath(e);
        }

        if (path != null && path.isNotEmpty) {
          if (!galleryPaths.contains(path)) {
            galleryPaths.add(path);
            
            // If the URL is obviously broken (double storage), ignore it and regenerate
            if (url != null && url.contains('/storage/http')) {
              url = null;
            }
            
            galleryUrls.add(url ?? NetworkUrl.fullUrl(path));
          }
        }
      }
    }
    
    final jsonUrls = json['image_urls'] as List?;
    if (jsonUrls != null && jsonUrls.isNotEmpty) {
      galleryUrls.clear();
      galleryUrls.addAll(jsonUrls.map((e) => e.toString()));
    }

    return ProductRow(
      id: _safeInt(json['id']) ?? 0,
      companyId: _safeInt(json['company_id']),
      code: json['code'] as String?,
      sku: json['sku'] as String? ?? '',
      name: json['name'] as String? ?? 'Unnamed Product',
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
      productCategoryId: _safeInt(json['product_category_id']),
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      barcode: json['barcode'] as String?,
      brand: json['brand'] as String?,
      brandAr: json['brand_ar'] as String?,
      brandId: _safeInt(json['brand_id']),
      baseUnitId: _safeInt(json['base_unit_id']),
      purchasePrice: json['purchase_price']?.toString(),
      salePrice: json['sale_price']?.toString(),
      minSalePrice: json['min_sale_price']?.toString(),
      isActive: (json['is_active'] ?? true) as bool,
      trackInventory: (json['track_inventory'] ?? true) as bool,
      image: imagePath,
      imageUrl: (providedUrl != null && providedUrl.isNotEmpty)
          ? providedUrl
          : (imagePath != null ? NetworkUrl.fullUrl(imagePath) : null),
      images: galleryPaths.isEmpty ? null : galleryPaths,
      imageUrls: galleryUrls.isEmpty ? null : galleryUrls,
      notes: json['notes'] as String?,
      notesAr: json['notes_ar'] as String?,
      hasVariants: (json['has_variants'] ?? false) as bool,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      tags: _parseTags(json['tags'] ?? json['product_tags']),
      properties: _parseProperties(json['properties'] ?? json['product_properties']),
    );
  }

  /// Safely parse a value that may be int, String, or null into int?.
  static int? _safeInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static List<FilterRow>? _parseTags(dynamic json) {
    if (json == null || json is! List) return null;
    return json.map((e) {
      if (e is Map) return FilterRow.fromJson(e.cast<String, dynamic>());
      if (e is int) return FilterRow(id: e, name: '', isActive: true);
      return FilterRow(id: 0, name: '', isActive: true);
    }).toList();
  }

  static List<PropertyRow>? _parseProperties(dynamic json) {
    if (json == null || json is! List) return null;
    return json.map((e) {
      if (e is Map) return PropertyRow.fromJson(e.cast<String, dynamic>());
      if (e is int) return PropertyRow(id: e, title: '', isActive: true);
      return PropertyRow(id: 0, title: '', isActive: true);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'code': code,
      'sku': sku,
      'name': name,
      'name_en': nameEn,
      'name_ar': nameAr,
      'product_category_id': productCategoryId,
      'description': description,
      'description_ar': descriptionAr,
      'barcode': barcode,
      'brand': brand,
      'brand_ar': brandAr,
      'brand_id': brandId,
      'base_unit_id': baseUnitId,
      'purchase_price': purchasePrice,
      'sale_price': salePrice,
      'min_sale_price': minSalePrice,
      'is_active': isActive,
      'track_inventory': trackInventory,
      'image': image,
      'notes': notes,
      'notes_ar': notesAr,
      'has_variants': hasVariants,
    };
  }
}
