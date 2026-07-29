import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/checkout/presentation/state/checkout_state.dart';
import 'package:erp/modules/webstore/cart/presentation/view_model/cart_view_model.dart';
import 'checkout_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';

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

  String? _lastPayloadKey;

  Future<void> calculateTotals({
    int? addressId,
    String? couponCode,
    int? paymentMethodId,
    int? pointsToRedeem,
  }) async {
    // Don't call the API without a valid address
    if (addressId == null) return;

    _pointsToRedeem = (pointsToRedeem != null && pointsToRedeem > 0) ? pointsToRedeem : null;

    final body = {
      'address_id': addressId,
      'payment_method_id': paymentMethodId ?? 1,
      if (couponCode != null && couponCode.isNotEmpty) 'coupon_code': couponCode,
      if (_pointsToRedeem != null) 'points_to_redeem': _pointsToRedeem,
    };

    final payloadKey = body.toString();
    if (_lastPayloadKey == payloadKey && (state is CheckoutCalculated || state is CheckoutCalculating)) {
      // Ignore duplicate API calls with identical parameters
      return;
    }

    _lastPayloadKey = payloadKey;
    state = const CheckoutCalculating();
    final repository = ref.read(checkoutRepositoryProvider);

    final result = await repository.calculateTotals(body);

    result.when(
      success: (data) => state = CheckoutCalculated(data),
      failure: (error) {
        _lastPayloadKey = null; // Reset on failure so retries are allowed
        state = CheckoutError(error.message);
      },
    );
  }

  int? _pointsToRedeem;

  int get pointsToRedeem => _pointsToRedeem ?? 0;

  void setPointsToRedeem(int pts) => _pointsToRedeem = pts > 0 ? pts : null;

  Future<void> confirmOrder({
    required String paymentMethod,
    required String address,
    required double totalAmount,
    int? addressId,
    int? paymentMethodId,
    String? couponCode,
    String? notes,
    int? pointsToRedeem,
  }) async {
    state = const CheckoutSubmitting();
    
    final cartItems = ref.read(cartProvider);
    if (cartItems.isEmpty) {
      state = CheckoutError(LocaleKeys.webstore.checkout.cart_empty_error.tr());
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

    final redeemPts = pointsToRedeem ?? _pointsToRedeem;
    final orderBody = {
      'address_id': addressId,
      'payment_method_id': finalPaymentMethodId,
      if (couponCode != null && couponCode.isNotEmpty) 'coupon_code': couponCode,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
      if (redeemPts != null && redeemPts > 0) 'points_to_redeem': redeemPts,
    };

    final repository = ref.read(checkoutRepositoryProvider);
    final result = await repository.placeOrder(orderBody);

    result.when(
      success: (data) {
        state = CheckoutSuccess(data);
        // Clear the local cart state since the server clears it automatically
        ref.read(cartProvider.notifier).clearLocalCart();
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
