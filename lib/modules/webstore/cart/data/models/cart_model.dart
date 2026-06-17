/// Cart Model — matches the server response from GET /api/store/cart
library;

import 'cart_item_model.dart';

class CartModel {
  final int id;
  final List<CartItemModel> items;
  final double subtotal;
  final int itemCount;
  final String? couponCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CartModel({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.itemCount,
    this.couponCode,
    this.createdAt,
    this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] is Map
        ? json['data'] as Map<String, dynamic>
        : json;

    final itemsRaw = data['items'];
    final itemsList = (itemsRaw is List ? itemsRaw : <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map((e) => CartItemModel.fromJson(e))
        .toList();

    return CartModel(
      id: data['id'] as int,
      items: itemsList,
      subtotal: _parseDouble(data['subtotal']),
      itemCount: data['item_count'] as int? ?? 0,
      couponCode: data['coupon_code'] as String?,
      createdAt: data['created_at'] != null ? DateTime.tryParse(data['created_at']) : null,
      updatedAt: data['updated_at'] != null ? DateTime.tryParse(data['updated_at']) : null,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  CartModel copyWith({
    int? id,
    List<CartItemModel>? items,
    double? subtotal,
    int? itemCount,
    String? couponCode,
  }) {
    return CartModel(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      itemCount: itemCount ?? this.itemCount,
      couponCode: couponCode ?? this.couponCode,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
