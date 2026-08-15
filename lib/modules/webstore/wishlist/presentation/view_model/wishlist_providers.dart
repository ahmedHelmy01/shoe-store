import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/catalog/data/repositories/wishlist_repository.dart';

final wishlistRepositoryProvider = Provider<IWishlistRepository>((ref) {
  return WishlistRepository();
});

final wishlistProvider =
    AsyncNotifierProvider<WishlistNotifier, List<WebStoreProduct>>(() {
  return WishlistNotifier();
});

class WishlistNotifier extends AsyncNotifier<List<WebStoreProduct>> {
  @override
  Future<List<WebStoreProduct>> build() async {
    final auth = ref.watch(authStateProvider);
    if (auth.status != AuthStatus.authenticated) {
      return const [];
    }
    return _fetchWishlist();
  }

  Future<List<WebStoreProduct>> _fetchWishlist() async {
    final repository = ref.read(wishlistRepositoryProvider);
    final result = await repository.getWishlist();
    return result.when(
      success: (data) {
        final list = (data['data'] as List?) ?? [];
        return list
            .whereType<Map<String, dynamic>>()
            .where((item) => item['product'] != null)
            .map((item) {
              final productData = item['product'] as Map<String, dynamic>;
              return WebStoreProduct.fromJson(productData);
            })
            .toList();
      },
      failure: (failure) {
        return <WebStoreProduct>[];
      },
    );
  }

  Future<bool> toggleWishlist(WebStoreProduct product) async {
    if (product.id == null) return false;
    final currentList = state.value ?? [];
    final isFav = currentList.any((p) => p.id == product.id);

    final updatedList = List<WebStoreProduct>.from(currentList);
    if (isFav) {
      updatedList.removeWhere((p) => p.id == product.id);
    } else {
      updatedList.add(product);
    }
    state = AsyncValue.data(updatedList);

    final repository = ref.read(wishlistRepositoryProvider);
    final result = isFav
        ? await repository.removeFromWishlist(product.id!)
        : await repository.addToWishlist(product.id!);

    return result.when(
      success: (_) => true,
      failure: (failure) {
        state = AsyncValue.data(currentList);
        return false;
      },
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchWishlist());
  }
}
