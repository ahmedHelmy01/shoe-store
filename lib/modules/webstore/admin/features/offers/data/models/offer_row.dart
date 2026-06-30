import 'package:erp/core/network/network_url.dart';

class OfferProduct {
  final int productId;
  final double? customPrice;

  const OfferProduct({required this.productId, this.customPrice});

  factory OfferProduct.fromJson(Map<String, dynamic> json) {
    final pivot = json['pivot'] as Map?;
    return OfferProduct(
      productId: _parseInt(json['product_id'] ?? json['id'] ?? pivot?['product_id']),
      customPrice: _parseDouble(json['custom_price'] ?? pivot?['custom_price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      if (customPrice != null) 'custom_price': customPrice,
    };
  }
}

class OfferRow {
  final int id;
  final String name;
  final String? nameAr;
  final String? description;
  final String? descriptionAr;
  final String discountType;
  final double discountValue;
  final String? startDate;
  final String? endDate;
  final String? image;
  final String? imageUrl;
  final bool isActive;
  final List<OfferProduct> products;

  const OfferRow({
    required this.id,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    required this.discountType,
    required this.discountValue,
    this.startDate,
    this.endDate,
    this.image,
    this.imageUrl,
    required this.isActive,
    this.products = const [],
  });

  bool get isPercentage => discountType == 'percentage';

  factory OfferRow.fromJson(Map<String, dynamic> json) {
    final rawType = json['discount_type'];
    String typeStr = 'percentage';
    if (rawType == 2 ||
        rawType?.toString() == '2' ||
        json['discount_type_label']?.toString().toLowerCase().contains('fixed') == true) {
      typeStr = 'fixed';
    }

    final imagePath = json['image']?.toString();
    final providedUrl = json['image_url']?.toString();

    final productsList = <OfferProduct>[];
    if (json['products'] is List) {
      for (final e in json['products'] as List) {
        if (e is Map) {
          productsList.add(OfferProduct.fromJson(e.cast<String, dynamic>()));
        }
      }
    }

    return OfferRow(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      nameAr: json['name_ar']?.toString(),
      description: json['description']?.toString(),
      descriptionAr: json['description_ar']?.toString(),
      discountType: typeStr,
      discountValue: _parseDouble(json['discount_value']),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      image: imagePath,
      imageUrl: (providedUrl != null && providedUrl.isNotEmpty)
          ? providedUrl
          : (imagePath != null && imagePath.isNotEmpty ? NetworkUrl.fullUrl(imagePath) : null),
      isActive: _parseBool(json['is_active']),
      products: productsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'description_ar': descriptionAr,
      'discount_type': discountType,
      'discount_value': discountValue,
      'start_date': startDate,
      'end_date': endDate,
      'image': image,
      'is_active': isActive,
      'products': products.map((p) => p.toJson()).toList(),
    };
  }
}

int _parseInt(dynamic value, [int defaultValue = 0]) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return double.tryParse(value.toString())?.toInt() ?? defaultValue;
}

double _parseDouble(dynamic value, [double defaultValue = 0.0]) {
  if (value == null) return defaultValue;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? defaultValue;
}

bool _parseBool(dynamic value, [bool defaultValue = false]) {
  if (value == null) return defaultValue;
  if (value is bool) return value;
  if (value is num) return value == 1;
  final str = value.toString().toLowerCase();
  return str == 'true' || str == '1';
}
