import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/orders/data/repositories/orders_repository.dart';

// ─── DI Providers ───────────────────────────────────────

final webstoreOrdersRepositoryProvider = Provider<IOrdersRepository>((ref) {
  return OrdersRepository();
});

// ─── 1) Orders List ─────────────────────────────────────

final ordersListProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(webstoreOrdersRepositoryProvider);
  final result = await repo.getOrders(queryParams: {
    'page': 1,
    'per_page': 25,
  });
  return result.when(
    success: (data) => data,
    failure: (error) => throw error.displayMessage,
  );
});

// ─── 2) Order Detail ────────────────────────────────────

final orderDetailProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, orderId) async {
  final repo = ref.watch(webstoreOrdersRepositoryProvider);
  final result = await repo.getOrderDetail(orderId);
  return result.when(
    success: (data) => data,
    failure: (error) => throw error.displayMessage,
  );
});

// ─── 3) Cancel Order ────────────────────────────────────

final cancelOrderProvider = FutureProvider.family<Map<String, dynamic>, ({int orderId, String? reason})>((ref, params) async {
  final repo = ref.watch(webstoreOrdersRepositoryProvider);
  final result = await repo.cancelOrder(params.orderId, reason: params.reason);
  return result.when(
    success: (data) => data,
    failure: (error) => throw error.displayMessage,
  );
});

// ─── 4) Rate Order ──────────────────────────────────────

final rateOrderProvider = FutureProvider.family<Map<String, dynamic>, ({int orderId, int rating, String? ratingText})>((ref, params) async {
  final repo = ref.watch(webstoreOrdersRepositoryProvider);
  final result = await repo.rateOrder(params.orderId, rating: params.rating, ratingText: params.ratingText);
  return result.when(
    success: (data) => data,
    failure: (error) => throw error.displayMessage,
  );
});

// ─── 5) Get Rating ──────────────────────────────────────

final orderRatingProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, orderId) async {
  final repo = ref.watch(webstoreOrdersRepositoryProvider);
  final result = await repo.getOrderRating(orderId);
  return result.when(
    success: (data) => data,
    failure: (error) => throw error.displayMessage,
  );
});

// ─── Track Order ────────────────────────────────────────

final orderTrackingProvider = FutureProvider.family<dynamic, int>((ref, orderId) async {
  final repo = ref.watch(webstoreOrdersRepositoryProvider);
  final result = await repo.trackOrder(orderId);
  return result.when(
    success: (data) => data,
    failure: (error) => throw error.displayMessage,
  );
});

// ─── Reorder ────────────────────────────────────────────

final reorderProvider = FutureProvider.family<dynamic, int>((ref, orderId) async {
  final repo = ref.watch(webstoreOrdersRepositoryProvider);
  final result = await repo.reorder(orderId);
  return result.when(
    success: (data) => data,
    failure: (error) => throw error.displayMessage,
  );
});

class WebStoreReorderLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setLoading(bool loading) => state = loading;
}

final webstoreReorderLoadingProvider = NotifierProvider.autoDispose<WebStoreReorderLoadingNotifier, bool>(WebStoreReorderLoadingNotifier.new);
