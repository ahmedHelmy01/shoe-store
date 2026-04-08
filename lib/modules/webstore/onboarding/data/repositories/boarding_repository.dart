import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/cms/data/datasource/webstore_cms_remote_datasource.dart';

abstract class IBoardingRepository {
  Future<ApiResult<Map<String, dynamic>>> getBoardings();
}

class BoardingRepository extends BaseRepository implements IBoardingRepository {
  final WebStoreCmsRemoteDataSource _remoteDataSource;
  BoardingRepository(this._remoteDataSource);

  @override
  Future<ApiResult<Map<String, dynamic>>> getBoardings() => 
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getBoardings());
}
