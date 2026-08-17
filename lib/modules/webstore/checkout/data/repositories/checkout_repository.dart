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

        final pts = (data['points_to_redeem'] as num?)?.toInt() ?? 0;
        final pointsDiscount = pts * 0.1;

        final couponCode = data['coupon_code']?.toString();
        double couponDiscount = 0;
        if (couponCode != null && couponCode.isNotEmpty) {
          final coupon = MockData.mockCoupons.firstWhere(
            (c) => c.code == couponCode,
            orElse: () => MockData.mockCoupons.first,
          );
          if (coupon.discountType == 'percentage') {
            couponDiscount = subtotal * coupon.discountValue / 100;
          } else {
            couponDiscount = coupon.discountValue.toDouble();
          }
        }

        final total = (subtotal + shipping - pointsDiscount - couponDiscount)
            .clamp(0.0, double.infinity)
            .toDouble();

        return {
          'subtotal': subtotal,
          'shipping': shipping,
          'discount': couponDiscount,
          'points_discount': pointsDiscount,
          'points_used': pts,
          'total': total,
        };
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> placeOrder(Map<String, dynamic> data) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 500));
        return {
          'message': 'تم تأكيد الطلب بنجاح',
          'id': 1004,
          'order_id': 1004,
          'order_number': '#1004',
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
