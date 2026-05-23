import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/checkout/data/repositories/checkout_repository.dart';
import 'package:erp/modules/webstore/checkout/presentation/state/checkout_state.dart';
import 'package:erp/modules/webstore/cart/presentation/view_model/cart_view_model.dart';
import 'checkout_providers.dart';

class CheckoutVm extends Notifier<CheckoutState> {
  @override
  CheckoutState build() {
    return const CheckoutInitial();
  }

  Future<void> validateCart() async {
    state = const CheckoutValidating();
    final repository = ref.read(checkoutRepositoryProvider);
    final result = await repository.validateCart();

    result.when(
      success: (data) => state = CheckoutValidated(data),
      failure: (error) => state = CheckoutError(error.message),
    );
  }

  Future<void> calculateTotals({
    int? addressId,
    String? couponCode,
    int? paymentMethodId,
  }) async {
    state = const CheckoutCalculating();
    final repository = ref.read(checkoutRepositoryProvider);

    final body = {
      'address_id': addressId ?? 5, // fallback to example address ID
      'payment_method_id': paymentMethodId ?? 1, // fallback to example payment ID
      if (couponCode != null && couponCode.isNotEmpty) 'coupon_code': couponCode,
    };

    final result = await repository.calculateTotals(body);

    result.when(
      success: (data) => state = CheckoutCalculated(data),
      failure: (error) => state = CheckoutError(error.message),
    );
  }

  Future<void> confirmOrder({
    required String paymentMethod,
    required String address,
    required double totalAmount,
    int? addressId,
    int? paymentMethodId,
    String? couponCode,
    String? notes,
  }) async {
    state = const CheckoutSubmitting();
    
    final cartItems = ref.read(cartProvider);
    if (cartItems.isEmpty) {
      state = const CheckoutError('العربة فارغة حالياً');
      return;
    }

    // Map payment method string to ID (as fallback)
    int finalPaymentMethodId = paymentMethodId ?? 1;
    if (paymentMethodId == null) {
      if (paymentMethod.toLowerCase().contains('visa')) {
        finalPaymentMethodId = 1;
      } else if (paymentMethod.toLowerCase().contains('instapay')) {
        finalPaymentMethodId = 2;
      } else if (paymentMethod.toLowerCase().contains('cash')) {
        finalPaymentMethodId = 3;
      }
    }

    final orderBody = {
      'address_id': addressId ?? 5,
      'payment_method_id': finalPaymentMethodId,
      if (couponCode != null && couponCode.isNotEmpty) 'coupon_code': couponCode,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
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

  Future<ApiResult<Map<String, dynamic>>> validateCoupon(String code) async {
    final repository = ref.read(checkoutRepositoryProvider);
    return await repository.validateCoupon(code);
  }
}

final checkoutVmProvider = NotifierProvider<CheckoutVm, CheckoutState>(() {
  return CheckoutVm();
});
