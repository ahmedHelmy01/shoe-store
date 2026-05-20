import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/branches/data/datasource/webstore_branch_remote_datasource.dart';
import 'package:erp/modules/webstore/branches/data/branch_model.dart';

abstract class IWebStoreBranchRepository {
  Future<ApiResult<List<BranchModel>>> getBranches();
}

class WebStoreBranchRepository extends BaseRepository implements IWebStoreBranchRepository {
  final WebStoreBranchRemoteDataSource _remoteDataSource;

  WebStoreBranchRepository(this._remoteDataSource);

  @override
  Future<ApiResult<List<BranchModel>>> getBranches() =>
      safeApiCall<List<BranchModel>>(() async {
        final response = await _remoteDataSource.getBranches();
        final List<dynamic> data = response['data'] ?? [];
        return data.map((e) => BranchModel.fromJson(e as Map<String, dynamic>)).toList();
      });
}
