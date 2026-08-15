import 'package:erp/core/mock/mock_data.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
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
  CartRepository();

  @override
  Future<ApiResult<CartModel>> getCart() =>
      safeApiCall<CartModel>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return MockData.mockCart;
      });

  @override
  Future<ApiResult<CartModel>> addItem(Map<String, dynamic> data) =>
      safeApiCall<CartModel>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return MockData.mockCart;
      });

  @override
  Future<ApiResult<CartModel>> updateItem(int itemId, {required int quantity}) =>
      safeApiCall<CartModel>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return MockData.mockCart;
      });

  @override
  Future<ApiResult<dynamic>> removeItem(int itemId) =>
      safeApiCall<dynamic>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
      });

  @override
  Future<ApiResult<dynamic>> clearCart() =>
      safeApiCall<dynamic>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
      });

  @override
  Future<ApiResult<CartModel>> reorder(int orderId) =>
      safeApiCall<CartModel>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return MockData.mockCart;
      });
}
