import 'package:erp/core/mock/mock_data.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/checkout/data/models/payment_method_model.dart';

abstract class ICheckoutRepository {
  Future<ApiResult<Map<String, dynamic>>> validateCart();
  Future<ApiResult<Map<String, dynamic>>> calculateTotals(Map<String, dynamic> data);
  Future<ApiResult<Map<String, dynamic>>> placeOrder(Map<String, dynamic> data);
  Future<ApiResult<Map<String, dynamic>>> validateCoupon(String code);
  Future<ApiResult<List<PaymentMethodModel>>> getPaymentMethods();
}

class CheckoutRepository extends BaseRepository implements ICheckoutRepository {
  CheckoutRepository();

  @override
  Future<ApiResult<Map<String, dynamic>>> validateCart() =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {
          'valid': true,
          'items_count': MockData.mockCart.itemCount,
          'subtotal': MockData.mockCart.subtotal,
        };
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> calculateTotals(Map<String, dynamic> data) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        final subtotal = MockData.mockCart.subtotal;
        const shipping = 50.0;
        return {
          'subtotal': subtotal,
          'shipping': shipping,
          'discount': 0,
          'total': subtotal + shipping,
        };
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> placeOrder(Map<String, dynamic> data) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 500));
        return {
          'message': 'تم تأكيد الطلب بنجاح',
          'order_id': 1004,
        };
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> validateCoupon(String code) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        final coupon = MockData.mockCoupons.firstWhere(
          (c) => c.code == code,
          orElse: () => MockData.mockCoupons.first,
        );
        return {
          'valid': true,
          'discount_type': coupon.discountType,
          'discount_value': coupon.discountValue,
          'description': coupon.description,
        };
      });

  @override
  Future<ApiResult<List<PaymentMethodModel>>> getPaymentMethods() =>
      safeApiCall<List<PaymentMethodModel>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return MockData.mockPaymentMethods;
      });
}
