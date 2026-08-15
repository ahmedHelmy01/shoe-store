import 'package:erp/core/mock/mock_data.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/branches/data/branch_model.dart';

abstract class IWebStoreBranchRepository {
  Future<ApiResult<List<BranchModel>>> getBranches();
}

class WebStoreBranchRepository extends BaseRepository implements IWebStoreBranchRepository {
  WebStoreBranchRepository();

  @override
  Future<ApiResult<List<BranchModel>>> getBranches() =>
      safeApiCall<List<BranchModel>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return MockData.mockBranches;
      });
}
