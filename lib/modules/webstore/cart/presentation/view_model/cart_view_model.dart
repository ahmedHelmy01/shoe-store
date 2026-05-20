import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/cart/data/models/cart_item_model.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  static const _cacheKey = 'webstore_cart_items_cache';

  @override
  List<CartItem> build() {
    _loadFromCache();
    return state;
  }

  void _loadFromCache() {
    final prefs = ref.read(sharedPreferencesProvider);
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      try {
        final List<dynamic> list = jsonDecode(cachedData);
        state = list.map((item) => CartItem.fromJson(item as Map<String, dynamic>)).toList();
      } catch (e) {
        debugPrint('❌ CartNotifier: Error loading cart cache: $e');
        state = [];
      }
    } else {
      state = [];
    }
  }

  void _saveToCache(List<CartItem> items) {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_cacheKey, jsonEncode(items.map((e) => e.toJson()).toList()));
  }

  void addToCart(WebStoreProduct product, {int quantity = 1}) {
    final exists = state.any((item) => item.product.id == product.id);
    if (exists) {
      incrementQuantity(product.id!, amount: quantity);
    } else {
      final updated = [...state, CartItem(product: product, quantity: quantity)];
      state = updated;
      _saveToCache(updated);
    }
  }

  void incrementQuantity(int productId, {int amount = 1}) {
    final updated = state.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: item.quantity + amount);
      }
      return item;
    }).toList();
    state = updated;
    _saveToCache(updated);
  }

  void decrementQuantity(int productId) {
    final updated = state.map((item) {
      if (item.product.id == productId && item.quantity > 1) {
        return item.copyWith(quantity: item.quantity - 1);
      }
      return item;
    }).toList();
    state = updated;
    _saveToCache(updated);
  }

  void removeFromCart(int productId) {
    final updated = state.where((item) => item.product.id != productId).toList();
    state = updated;
    _saveToCache(updated);
  }

  void clearCart() {
    state = [];
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.remove(_cacheKey);
  }

  double get subtotal => state.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  double get shipping => state.isEmpty ? 0.0 : 25.0;
  double get total => subtotal + shipping;
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});
