class ProductRow {
  final int id;
  final String name;
  final String sku;
  final double? price;
  final String? description;
  final bool isActive;

  ProductRow({
    required this.id,
    required this.name,
    required this.sku,
    this.price,
    this.description,
    this.isActive = true,
  });

  factory ProductRow.fromJson(Map<String, dynamic> json) {
    return ProductRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unnamed Product',
      sku: json['sku'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble(),
      description: json['description'] as String?,
      isActive: (json['active'] ?? json['is_active'] ?? true) as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'price': price,
      'description': description,
      'is_active': isActive,
    };
  }
}
