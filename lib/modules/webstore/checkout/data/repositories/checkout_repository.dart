import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/checkout/data/datasource/webstore_checkout_remote_datasource.dart';
import 'package:erp/modules/webstore/checkout/data/models/payment_method_model.dart';

abstract class ICheckoutRepository {
  Future<ApiResult<Map<String, dynamic>>> validateCart();
  Future<ApiResult<Map<String, dynamic>>> calculateTotals(Map<String, dynamic> data);
  Future<ApiResult<Map<String, dynamic>>> placeOrder(Map<String, dynamic> data);
  Future<ApiResult<Map<String, dynamic>>> validateCoupon(String code);
  Future<ApiResult<List<PaymentMethodModel>>> getPaymentMethods();
}

class CheckoutRepository extends BaseRepository implements ICheckoutRepository {
  final WebStoreCheckoutRemoteDataSource _remoteDataSource;
  CheckoutRepository(this._remoteDataSource);

  @override
  Future<ApiResult<Map<String, dynamic>>> validateCart() =>
      safeApiCall<Map<String, dynamic>>(() async {
        final res = await _remoteDataSource.validateCart();
        return res as Map<String, dynamic>;
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> calculateTotals(Map<String, dynamic> data) =>
      safeApiCall<Map<String, dynamic>>(() async {
        final res = await _remoteDataSource.calculateTotals(data);
        return res as Map<String, dynamic>;
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> placeOrder(Map<String, dynamic> data) =>
      safeApiCall<Map<String, dynamic>>(() async {
        final res = await _remoteDataSource.placeOrder(data);
        return res as Map<String, dynamic>;
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> validateCoupon(String code) =>
      safeApiCall<Map<String, dynamic>>(() async {
        final res = await _remoteDataSource.validateCoupon(code);
        return res as Map<String, dynamic>;
      });

  @override
  Future<ApiResult<List<PaymentMethodModel>>> getPaymentMethods() =>
      safeApiCall<List<PaymentMethodModel>>(() async {
        final res = await _remoteDataSource.getPaymentMethods();
        final dataMap = res as Map<String, dynamic>;
        final list = dataMap['data'] as List;
        return list.map((item) => PaymentMethodModel.fromJson(item as Map<String, dynamic>)).toList();
      });
}
