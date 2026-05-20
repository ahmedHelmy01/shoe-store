import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/checkout/data/repositories/checkout_repository.dart';
import 'package:erp/modules/webstore/checkout/presentation/state/checkout_state.dart';
import 'package:erp/modules/webstore/cart/presentation/view_model/cart_view_model.dart';
import 'checkout_providers.dart';

class CheckoutVm extends Notifier<CheckoutState> {
  @override
  CheckoutState build() {
    return const CheckoutInitial();
  }

  Future<void> getSummary() async {
    state = const CheckoutLoading();
    final repository = ref.read(checkoutRepositoryProvider);
    final result = await repository.getCheckoutSummary();

    result.when(
      success: (data) => state = CheckoutSummaryLoaded(data),
      failure: (error) => state = CheckoutError(error.message),
    );
  }

  Future<void> confirmOrder({
    required String paymentMethod,
    required String address,
    required double totalAmount,
  }) async {
    state = const CheckoutSubmitting();
    
    final cartItems = ref.read(cartProvider);
    if (cartItems.isEmpty) {
      state = const CheckoutError('العربة فارغة حالياً');
      return;
    }

    final orderBody = {
      'payment_method': paymentMethod,
      'address': address,
      'total': totalAmount,
      'items': cartItems.map((item) => {
        'product_id': item.product.id,
        'quantity': item.quantity,
        'price': item.product.price,
      }).toList(),
    };

    final repository = ref.read(checkoutRepositoryProvider);
    final result = await repository.placeOrder(orderBody);

    result.when(
      success: (data) {
        state = CheckoutSuccess(data);
        // Clear the cart on successful order placement
        ref.read(cartProvider.notifier).clearCart();
      },
      failure: (error) => state = CheckoutError(error.message),
    );
  }
}

final checkoutVmProvider = NotifierProvider<CheckoutVm, CheckoutState>(() {
  return CheckoutVm();
});
