import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/shared/data/datasource/webstore_remote_datasource.dart';

abstract class ICatalogRepository {
  Future<ApiResult<Map<String, dynamic>>> getProducts({Map<String, dynamic>? queryParams});
  Future<ApiResult<Map<String, dynamic>>> getProductDetail(int id);
  Future<ApiResult<Map<String, dynamic>>> getCategories({Map<String, dynamic>? queryParams});
  Future<ApiResult<Map<String, dynamic>>> getCategoryDetail(int id);
  Future<ApiResult<Map<String, dynamic>>> searchProducts(String query);
}

class CatalogRepository extends BaseRepository implements ICatalogRepository {
  final WebStoreRemoteDataSource _remoteDataSource;

  CatalogRepository(this._remoteDataSource);

  @override
  Future<ApiResult<Map<String, dynamic>>> getProducts({Map<String, dynamic>? queryParams}) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getProducts(queryParams: queryParams));

  @override
  Future<ApiResult<Map<String, dynamic>>> getProductDetail(int id) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getProductDetail(id));

  @override
  Future<ApiResult<Map<String, dynamic>>> getCategories({Map<String, dynamic>? queryParams}) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getCategories(queryParams: queryParams));

  @override
  Future<ApiResult<Map<String, dynamic>>> getCategoryDetail(int id) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getCategoryDetail(id));

  @override
  Future<ApiResult<Map<String, dynamic>>> searchProducts(String query) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.searchProducts(query));
}
