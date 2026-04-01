import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/shared/data/datasource/webstore_remote_datasource.dart';

abstract class ICartRepository {
  Future<ApiResult<Map<String, dynamic>>> getCart();
  Future<ApiResult<Map<String, dynamic>>> addToCart(Map<String, dynamic> data);
  Future<ApiResult<Map<String, dynamic>>> updateCart(Map<String, dynamic> data);
  Future<ApiResult<Map<String, dynamic>>> removeFromCart(Map<String, dynamic> data);
  Future<ApiResult<Map<String, dynamic>>> clearCart();
  Future<ApiResult<Map<String, dynamic>>> applyCoupon(String code);
}

class CartRepository extends BaseRepository implements ICartRepository {
  final WebStoreRemoteDataSource _remoteDataSource;
  CartRepository(this._remoteDataSource);

  @override
  Future<ApiResult<Map<String, dynamic>>> getCart() => 
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getCart());

  @override
  Future<ApiResult<Map<String, dynamic>>> addToCart(Map<String, dynamic> data) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.addToCart(data));

  @override
  Future<ApiResult<Map<String, dynamic>>> updateCart(Map<String, dynamic> data) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.updateCart(data));

  @override
  Future<ApiResult<Map<String, dynamic>>> removeFromCart(Map<String, dynamic> data) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.removeFromCart(data));

  @override
  Future<ApiResult<Map<String, dynamic>>> clearCart() => 
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.clearCart());

  @override
  Future<ApiResult<Map<String, dynamic>>> applyCoupon(String code) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.applyCoupon(code));
}
