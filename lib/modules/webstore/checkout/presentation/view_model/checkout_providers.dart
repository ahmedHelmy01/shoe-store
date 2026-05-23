import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/checkout/data/datasource/webstore_checkout_remote_datasource.dart';
import 'package:erp/modules/webstore/checkout/data/repositories/checkout_repository.dart';
import 'package:erp/modules/webstore/checkout/data/models/payment_method_model.dart';

final checkoutRemoteDataSourceProvider = Provider<WebStoreCheckoutRemoteDataSource>((ref) {
  return WebStoreCheckoutRemoteDataSource(ref.watch(networkServiceProvider));
});

final checkoutRepositoryProvider = Provider<ICheckoutRepository>((ref) {
  return CheckoutRepository(ref.watch(checkoutRemoteDataSourceProvider));
});

final paymentMethodsProvider = FutureProvider<List<PaymentMethodModel>>((ref) async {
  final repo = ref.watch(checkoutRepositoryProvider);
  final result = await repo.getPaymentMethods();
  return result.when(
    success: (data) => data,
    failure: (fail) => throw fail.message,
  );
});
