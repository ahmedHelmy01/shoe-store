import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/checkout/data/repositories/checkout_repository.dart';
import 'package:erp/modules/webstore/checkout/data/models/payment_method_model.dart';

final checkoutRepositoryProvider = Provider<ICheckoutRepository>((ref) {
  return CheckoutRepository();
});

final paymentMethodsProvider = FutureProvider<List<PaymentMethodModel>>((ref) async {
  final repo = ref.watch(checkoutRepositoryProvider);
  final result = await repo.getPaymentMethods();
  return result.when(
    success: (data) => data,
    failure: (fail) => throw fail.message,
  );
});
