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
  final String? notes;
  final String? notesAr;
  final bool hasVariants;
  final String? createdAt;
  final String? updatedAt;

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
    this.notes,
    this.notesAr,
    this.hasVariants = false,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductRow.fromJson(Map<String, dynamic> json) {
    return ProductRow(
      id: json['id'] as int? ?? 0,
      companyId: json['company_id'] as int?,
      code: json['code'] as String?,
      sku: json['sku'] as String? ?? '',
      name: json['name'] as String? ?? 'Unnamed Product',
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
      productCategoryId: json['product_category_id'] as int?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      barcode: json['barcode'] as String?,
      brand: json['brand'] as String?,
      brandAr: json['brand_ar'] as String?,
      brandId: json['brand_id'] as int?,
      baseUnitId: json['base_unit_id'] as int?,
      purchasePrice: json['purchase_price']?.toString(),
      salePrice: json['sale_price']?.toString(),
      minSalePrice: json['min_sale_price']?.toString(),
      isActive: (json['is_active'] ?? true) as bool,
      trackInventory: (json['track_inventory'] ?? true) as bool,
      image: json['image'] as String?,
      notes: json['notes'] as String?,
      notesAr: json['notes_ar'] as String?,
      hasVariants: (json['has_variants'] ?? false) as bool,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
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

