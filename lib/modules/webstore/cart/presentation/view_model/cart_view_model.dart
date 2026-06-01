import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/cart/data/models/cart_item_model.dart';
import 'cart_providers.dart';

class CartNotifier extends Notifier<List<CartItemModel>> {
  static const _cacheKey = 'webstore_cart_items_cache';
  
  int? _cartId;
  double? _serverSubtotal;
  bool _isLoading = false;

  int? get cartId => _cartId;
  bool get isLoading => _isLoading;

  @override
  List<CartItemModel> build() {
    _loadFromCache();
    // Fetch latest cart state from server
    Future.microtask(() => fetchCart());
    return state;
  }

  void _loadFromCache() {
    final prefs = ref.read(sharedPreferencesProvider);
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      try {
        final List<dynamic> list = jsonDecode(cachedData);
        state = list.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>)).toList();
      } catch (e) {
        debugPrint('❌ CartNotifier: Error loading cart cache: $e');
        state = [];
      }
    } else {
      state = [];
    }
  }

  void _saveToCache(List<CartItemModel> items) {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_cacheKey, jsonEncode(items.map((e) => e.toJson()).toList()));
  }

  Future<void> fetchCart() async {
    _isLoading = true;
    final repository = ref.read(cartRepositoryProvider);
    final result = await repository.getCart();

    result.when(
      success: (cart) {
        _cartId = cart.id;
        _serverSubtotal = cart.subtotal;
        state = cart.items;
        _saveToCache(cart.items);
        _isLoading = false;
      },
      failure: (error) {
        debugPrint('❌ CartNotifier: Failed to fetch cart: ${error.message}');
        _isLoading = false;
      },
    );
  }

  Future<void> addToCart(WebStoreProduct product, {int quantity = 1}) async {
    // If the product is already in the cart, increment its quantity
    final existingItem = state.where((item) => item.product.id == product.id).firstOrNull;
    if (existingItem != null) {
      await incrementQuantity(product.id!, amount: quantity);
      return;
    }

    _isLoading = true;
    final repository = ref.read(cartRepositoryProvider);
    final result = await repository.addItem({
      'product_id': product.id,
      'quantity': quantity,
    });

    result.when(
      success: (cart) {
        _cartId = cart.id;
        _serverSubtotal = cart.subtotal;
        state = cart.items;
        _saveToCache(cart.items);
        _isLoading = false;
      },
      failure: (error) {
        debugPrint('❌ CartNotifier: Failed to add item: ${error.message}');
        _isLoading = false;
      },
    );
  }

  Future<void> incrementQuantity(int productId, {int amount = 1}) async {
    final item = state.where((item) => item.product.id == productId).firstOrNull;
    if (item == null) return;

    _isLoading = true;
    final repository = ref.read(cartRepositoryProvider);
    final result = await repository.updateItem(item.id, quantity: item.quantity + amount);

    result.when(
      success: (cart) {
        _cartId = cart.id;
        _serverSubtotal = cart.subtotal;
        state = cart.items;
        _saveToCache(cart.items);
        _isLoading = false;
      },
      failure: (error) {
        debugPrint('❌ CartNotifier: Failed to increment quantity: ${error.message}');
        _isLoading = false;
      },
    );
  }

  Future<void> decrementQuantity(int productId) async {
    final item = state.where((item) => item.product.id == productId).firstOrNull;
    if (item == null || item.quantity <= 1) return;

    _isLoading = true;
    final repository = ref.read(cartRepositoryProvider);
    final result = await repository.updateItem(item.id, quantity: item.quantity - 1);

    result.when(
      success: (cart) {
        _cartId = cart.id;
        _serverSubtotal = cart.subtotal;
        state = cart.items;
        _saveToCache(cart.items);
        _isLoading = false;
      },
      failure: (error) {
        debugPrint('❌ CartNotifier: Failed to decrement quantity: ${error.message}');
        _isLoading = false;
      },
    );
  }

  Future<void> removeFromCart(int productId) async {
    final item =
        state.where((item) => item.product.id == productId).firstOrNull;
    if (item == null) return;

    // Track loading state for this specific product
    ref.read(cartDeletingItemsProvider.notifier).add(productId);

    final repository = ref.read(cartRepositoryProvider);
    final result = await repository.removeItem(item.id);

    result.when(
      success: (_) {
        // Manually remove item from local state since API doesn't return updated cart
        state = state.where((i) => i.product.id != productId).toList();
        _saveToCache(state);

        // Update subtotal locally or fetch cart to sync all totals
        _serverSubtotal = state.fold<double>(
            0.0, (sum, i) => sum + (i.product.price * i.quantity));
      },
      failure: (error) {
        debugPrint('❌ CartNotifier: Failed to remove item: ${error.message}');
      },
    );

    // Remove from tracking
    ref.read(cartDeletingItemsProvider.notifier).remove(productId);
  }

  Future<void> clearCart() async {
    _isLoading = true;
    final repository = ref.read(cartRepositoryProvider);
    final result = await repository.clearCart();

    result.when(
      success: (_) {
        clearLocalCart();
        _isLoading = false;
      },
      failure: (error) {
        debugPrint('❌ CartNotifier: Failed to clear cart: ${error.message}');
        _isLoading = false;
      },
    );
  }

  void clearLocalCart() {
    state = [];
    _cartId = null;
    _serverSubtotal = null;
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.remove(_cacheKey);
  }

  Future<void> reorder(int orderId) async {
    _isLoading = true;
    final repository = ref.read(cartRepositoryProvider);
    final result = await repository.reorder(orderId);

    return result.when(
      success: (cart) {
        _cartId = cart.id;
        _serverSubtotal = cart.subtotal;
        state = cart.items;
        _saveToCache(cart.items);
        _isLoading = false;
      },
      failure: (error) {
        _isLoading = false;
        debugPrint('❌ CartNotifier: Failed to reorder: ${error.message}');
        throw error.displayMessage;
      },
    );
  }

  double get subtotal => _serverSubtotal ?? state.fold<double>(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  double get shipping => state.isEmpty ? 0.0 : 25.0;
  double get total => subtotal + shipping;
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItemModel>>(CartNotifier.new);

final cartDeletingItemsProvider = NotifierProvider<CartDeletingItemsNotifier, Set<int>>(CartDeletingItemsNotifier.new);

class CartDeletingItemsNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() => {};

  void add(int id) => state = {...state, id};
  void remove(int id) => state = state.where((i) => i != id).toSet();
}
