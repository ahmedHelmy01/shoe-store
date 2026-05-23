import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/cart/data/datasource/webstore_cart_remote_datasource.dart';
import 'package:erp/modules/webstore/cart/data/repositories/cart_repository.dart';

final cartRemoteDataSourceProvider = Provider<WebStoreCartRemoteDataSource>((ref) {
  return WebStoreCartRemoteDataSource(ref.watch(networkServiceProvider));
});

final cartRepositoryProvider = Provider<ICartRepository>((ref) {
  return CartRepository(ref.watch(cartRemoteDataSourceProvider));
});
