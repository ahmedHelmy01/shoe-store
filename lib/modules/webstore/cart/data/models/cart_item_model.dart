/// Cart Item Model — matches the server response for cart items
///
/// Each item has its own id (different from product id), product details,
/// variant, quantity, unit_price, discount, and line_total.
library;

import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';

class CartItemModel {
  final int id;
  final WebStoreProduct product;
  final Map<String, dynamic>? variant;
  final int quantity;
  final double unitPrice;
  final double discount;
  final double lineTotal;
  final DateTime? createdAt;

  const CartItemModel({
    required this.id,
    required this.product,
    this.variant,
    required this.quantity,
    required this.unitPrice,
    this.discount = 0.0,
    required this.lineTotal,
    this.createdAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as int,
      product: WebStoreProduct.fromJson(json['product'] as Map<String, dynamic>),
      variant: json['variant'] as Map<String, dynamic>?,
      quantity: json['quantity'] as int? ?? 1,
      unitPrice: _parseDouble(json['unit_price']),
      discount: _parseDouble(json['discount']),
      lineTotal: _parseDouble(json['line_total']),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }

  CartItemModel copyWith({
    int? id,
    WebStoreProduct? product,
    int? quantity,
    double? unitPrice,
    double? discount,
    double? lineTotal,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      variant: variant,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discount: discount ?? this.discount,
      lineTotal: lineTotal ?? this.lineTotal,
      createdAt: createdAt,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'variant': variant,
      'quantity': quantity,
      'unit_price': unitPrice,
      'discount': discount,
      'line_total': lineTotal,
    };
  }
}
