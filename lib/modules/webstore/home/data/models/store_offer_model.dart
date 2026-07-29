class StoreOfferProductModel {
  final int id;
  final String name;
  final String? nameEn;
  final String? nameAr;
  final double salePrice;
  final double? customPrice;
  final String? imageUrl;

  StoreOfferProductModel({
    required this.id,
    required this.name,
    this.nameEn,
    this.nameAr,
    required this.salePrice,
    this.customPrice,
    this.imageUrl,
  });

  factory StoreOfferProductModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    int parseInt(dynamic val) {
      if (val == null) return 0;
      if (val is int) return val;
      return int.tryParse(val.toString()) ?? 0;
    }

    return StoreOfferProductModel(
      id: parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      nameEn: json['name_en']?.toString(),
      nameAr: json['name_ar']?.toString(),
      salePrice: parseDouble(json['sale_price']),
      customPrice: json['custom_price'] != null ? parseDouble(json['custom_price']) : null,
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'name_ar': nameAr,
      'sale_price': salePrice,
      'custom_price': customPrice,
      'image_url': imageUrl,
    };
  }
}

class StoreOfferModel {
  final int id;
  final String name;
  final String? nameAr;
  final String? description;
  final String? descriptionAr;
  final int discountType;
  final String? discountTypeLabel;
  final double discountValue;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? image;
  final String? imageUrl;
  final List<StoreOfferProductModel> products;

  StoreOfferModel({
    required this.id,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    required this.discountType,
    this.discountTypeLabel,
    required this.discountValue,
    this.startDate,
    this.endDate,
    required this.isActive,
    this.image,
    this.imageUrl,
    required this.products,
  });

  factory StoreOfferModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    int parseInt(dynamic val) {
      if (val == null) return 0;
      if (val is int) return val;
      return int.tryParse(val.toString()) ?? 0;
    }

    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      try {
        return DateTime.parse(val.toString());
      } catch (_) {
        return null;
      }
    }

    final rawProducts = json['products'] as List? ?? [];

    return StoreOfferModel(
      id: parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      nameAr: json['name_ar']?.toString(),
      description: json['description']?.toString(),
      descriptionAr: json['description_ar']?.toString(),
      discountType: parseInt(json['discount_type']),
      discountTypeLabel: json['discount_type_label']?.toString(),
      discountValue: parseDouble(json['discount_value']),
      startDate: parseDate(json['start_date']),
      endDate: parseDate(json['end_date']),
      isActive: json['is_active'] == true || json['is_active'] == 1 || json['is_active'] == '1',
      image: json['image']?.toString(),
      imageUrl: json['image_url']?.toString(),
      products: rawProducts.map((p) => StoreOfferProductModel.fromJson(p as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'description_ar': descriptionAr,
      'discount_type': discountType,
      'discount_type_label': discountTypeLabel,
      'discount_value': discountValue,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive,
      'image': image,
      'image_url': imageUrl,
      'products': products.map((p) => p.toJson()).toList(),
    };
  }
}
