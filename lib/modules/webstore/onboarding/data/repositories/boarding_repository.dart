import 'package:erp/core/mock/mock_data.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';

abstract class IBoardingRepository {
  Future<ApiResult<Map<String, dynamic>>> getBoardings();
}

class BoardingRepository extends BaseRepository implements IBoardingRepository {
  BoardingRepository();

  @override
  Future<ApiResult<Map<String, dynamic>>> getBoardings() =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {
          'data': MockData.mockBoardings.map((e) => e.toJson()).toList(),
        };
      });
}
