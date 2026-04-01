import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/shared/data/datasource/webstore_remote_datasource.dart';

abstract class IWishlistRepository {
  Future<ApiResult<Map<String, dynamic>>> getWishlist();
  Future<ApiResult<Map<String, dynamic>>> addToWishlist(int productId);
  Future<ApiResult<Map<String, dynamic>>> removeFromWishlist(int productId);
}

class WishlistRepository extends BaseRepository implements IWishlistRepository {
  final WebStoreRemoteDataSource _remoteDataSource;
  WishlistRepository(this._remoteDataSource);

  @override
  Future<ApiResult<Map<String, dynamic>>> getWishlist() => 
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getWishlist());

  @override
  Future<ApiResult<Map<String, dynamic>>> addToWishlist(int productId) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.addToWishlist(productId));

  @override
  Future<ApiResult<Map<String, dynamic>>> removeFromWishlist(int productId) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.removeFromWishlist(productId));
}
