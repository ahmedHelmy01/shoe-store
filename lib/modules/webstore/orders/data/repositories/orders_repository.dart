import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/orders/data/datasource/webstore_orders_remote_datasource.dart';

abstract class IOrdersRepository {
  Future<ApiResult<Map<String, dynamic>>> getOrders({Map<String, dynamic>? queryParams});
  Future<ApiResult<Map<String, dynamic>>> getOrderDetail(int id);
  Future<ApiResult<Map<String, dynamic>>> cancelOrder(int id, {String? reason});
  Future<ApiResult<Map<String, dynamic>>> rateOrder(int id, {required int rating, String? ratingText});
  Future<ApiResult<Map<String, dynamic>>> getOrderRating(int id);
  Future<ApiResult<dynamic>> trackOrder(int id);
  Future<ApiResult<dynamic>> reorder(int orderId);
}

class OrdersRepository extends BaseRepository implements IOrdersRepository {
  final WebStoreOrdersRemoteDataSource _remoteDataSource;
  OrdersRepository(this._remoteDataSource);

  @override
  Future<ApiResult<Map<String, dynamic>>> getOrders({Map<String, dynamic>? queryParams}) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getOrders(queryParams: queryParams));

  @override
  Future<ApiResult<Map<String, dynamic>>> getOrderDetail(int id) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getOrderDetail(id));

  @override
  Future<ApiResult<Map<String, dynamic>>> cancelOrder(int id, {String? reason}) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.cancelOrder(id, reason: reason));

  @override
  Future<ApiResult<Map<String, dynamic>>> rateOrder(int id, {required int rating, String? ratingText}) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.rateOrder(id, rating: rating, ratingText: ratingText));

  @override
  Future<ApiResult<Map<String, dynamic>>> getOrderRating(int id) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getOrderRating(id));

  @override
  Future<ApiResult<dynamic>> trackOrder(int id) =>
      safeApiCall<dynamic>(() => _remoteDataSource.trackOrder(id));

  @override
  Future<ApiResult<dynamic>> reorder(int orderId) =>
      safeApiCall<dynamic>(() => _remoteDataSource.reorder(orderId));
}
