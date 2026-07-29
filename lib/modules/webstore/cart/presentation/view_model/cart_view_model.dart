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
    final auth = ref.watch(authStateProvider);
    if (auth.status != AuthStatus.authenticated) {
      // Clear cache when logged out
      final prefs = ref.read(sharedPreferencesProvider);
      prefs.remove(_cacheKey);
      _cartId = null;
      _serverSubtotal = null;
      return const [];
    }

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
    final auth = ref.read(authStateProvider);
    if (auth.status != AuthStatus.authenticated) return;

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

  Future<bool> addToCart(WebStoreProduct product, {int quantity = 1}) async {
    // If the product is already in the cart, increment its quantity
    final existingItem = state.where((item) => item.product.id == product.id).firstOrNull;
    if (existingItem != null) {
      await incrementQuantity(product.id!, amount: quantity);
      return true;
    }

    _isLoading = true;
    final repository = ref.read(cartRepositoryProvider);
    final result = await repository.addItem({
      'product_id': product.id,
      'quantity': quantity,
    });

    return result.when(
      success: (cart) {
        _cartId = cart.id;
        _serverSubtotal = cart.subtotal;
        state = cart.items;
        _saveToCache(cart.items);
        _isLoading = false;
        return true;
      },
      failure: (error) {
        debugPrint('❌ CartNotifier: Failed to add item: ${error.message}');
        _isLoading = false;
        return false;
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

    // Track loading state
    ref.read(cartDeletingItemsProvider.notifier).add(productId);

    // Capture state for potential rollback
    final previousState = state;
    final previousSubtotal = _serverSubtotal;

    // 1. Optimistic Update: Remove from local state immediately to satisfy Dismissible
    state = state.where((i) => i.product.id != productId).toList();
    _saveToCache(state);
    _serverSubtotal = state.fold<double>(
        0.0, (sum, i) => sum + (i.product.price * i.quantity));

    final repository = ref.read(cartRepositoryProvider);
    final result = await repository.removeItem(item.id);

    result.when(
      success: (_) {
        debugPrint('✅ CartNotifier: Item $productId removed successfully');
      },
      failure: (error) {
        debugPrint('❌ CartNotifier: Failed to remove item $productId: ${error.message}');
        // Rollback on failure
        state = previousState;
        _serverSubtotal = previousSubtotal;
        _saveToCache(state);
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

  double? _serverShipping;

  void setServerShipping(double? cost) {
    _serverShipping = cost;
  }

  double get subtotal => _serverSubtotal ?? state.fold<double>(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  double get shipping => _serverShipping ?? 0.0;
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
