import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/shared/data/datasource/webstore_remote_datasource.dart';

abstract class ICMSRepository {
  Future<ApiResult<Map<String, dynamic>>> getSliders();
  Future<ApiResult<Map<String, dynamic>>> getBanners();
  Future<ApiResult<Map<String, dynamic>>> getPages();
  Future<ApiResult<Map<String, dynamic>>> getPageDetail(int id);
}

class CMSRepository extends BaseRepository implements ICMSRepository {
  final WebStoreRemoteDataSource _remoteDataSource;
  CMSRepository(this._remoteDataSource);

  @override
  Future<ApiResult<Map<String, dynamic>>> getSliders() => 
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getSliders());

  @override
  Future<ApiResult<Map<String, dynamic>>> getBanners() => 
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getBanners());

  @override
  Future<ApiResult<Map<String, dynamic>>> getPages() => 
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getPages());

  @override
  Future<ApiResult<Map<String, dynamic>>> getPageDetail(int id) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getPageDetail(id));
}
