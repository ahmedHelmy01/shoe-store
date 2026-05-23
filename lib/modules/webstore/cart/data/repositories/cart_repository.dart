import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/cart/data/datasource/webstore_cart_remote_datasource.dart';
import 'package:erp/modules/webstore/cart/data/models/cart_model.dart';

abstract class ICartRepository {
  Future<ApiResult<CartModel>> getCart();
  Future<ApiResult<CartModel>> addItem(Map<String, dynamic> data);
  Future<ApiResult<CartModel>> updateItem(int itemId, {required int quantity});
  Future<ApiResult<dynamic>> removeItem(int itemId);
  Future<ApiResult<dynamic>> clearCart();
  Future<ApiResult<CartModel>> reorder(int orderId);
}

class CartRepository extends BaseRepository implements ICartRepository {
  final WebStoreCartRemoteDataSource _remoteDataSource;
  CartRepository(this._remoteDataSource);

  @override
  Future<ApiResult<CartModel>> getCart() => 
      safeApiCall<CartModel>(() async {
        final res = await _remoteDataSource.getCart();
        return CartModel.fromJson(res as Map<String, dynamic>);
      });

  @override
  Future<ApiResult<CartModel>> addItem(Map<String, dynamic> data) =>
      safeApiCall<CartModel>(() async {
        final res = await _remoteDataSource.addItem(data);
        return CartModel.fromJson(res as Map<String, dynamic>);
      });

  @override
  Future<ApiResult<CartModel>> updateItem(int itemId, {required int quantity}) =>
      safeApiCall<CartModel>(() async {
        final res = await _remoteDataSource.updateItem(itemId, quantity: quantity);
        return CartModel.fromJson(res as Map<String, dynamic>);
      });

  @override
  Future<ApiResult<dynamic>> removeItem(int itemId) =>
      safeApiCall<dynamic>(() => _remoteDataSource.removeItem(itemId));

  @override
  Future<ApiResult<dynamic>> clearCart() => 
      safeApiCall<dynamic>(() => _remoteDataSource.clearCart());

  @override
  Future<ApiResult<CartModel>> reorder(int orderId) =>
      safeApiCall<CartModel>(() async {
        final res = await _remoteDataSource.reorder(orderId);
        return CartModel.fromJson(res as Map<String, dynamic>);
      });
}
