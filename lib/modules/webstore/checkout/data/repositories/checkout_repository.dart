import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/checkout/data/datasource/webstore_checkout_remote_datasource.dart';

abstract class ICheckoutRepository {
  Future<ApiResult<Map<String, dynamic>>> getCheckoutSummary();
  Future<ApiResult<Map<String, dynamic>>> placeOrder(Map<String, dynamic> data);
}

class CheckoutRepository extends BaseRepository implements ICheckoutRepository {
  final WebStoreCheckoutRemoteDataSource _remoteDataSource;
  CheckoutRepository(this._remoteDataSource);

  @override
  Future<ApiResult<Map<String, dynamic>>> getCheckoutSummary() =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getCheckoutSummary());

  @override
  Future<ApiResult<Map<String, dynamic>>> placeOrder(Map<String, dynamic> data) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.placeOrder(data));
}
