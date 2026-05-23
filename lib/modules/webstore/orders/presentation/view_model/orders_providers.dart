import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/orders/data/datasource/webstore_orders_remote_datasource.dart';
import 'package:erp/modules/webstore/orders/data/repositories/orders_repository.dart';

final webstoreOrdersRemoteDataSourceProvider = Provider<WebStoreOrdersRemoteDataSource>((ref) {
  return WebStoreOrdersRemoteDataSource(ref.watch(networkServiceProvider));
});

final webstoreOrdersRepositoryProvider = Provider<IOrdersRepository>((ref) {
  return OrdersRepository(ref.watch(webstoreOrdersRemoteDataSourceProvider));
});

final orderTrackingProvider = FutureProvider.family<dynamic, int>((ref, orderId) async {
  final repo = ref.watch(webstoreOrdersRepositoryProvider);
  final result = await repo.trackOrder(orderId);
  return result.when(
    success: (data) => data,
    failure: (error) => throw error.message,
  );
});
