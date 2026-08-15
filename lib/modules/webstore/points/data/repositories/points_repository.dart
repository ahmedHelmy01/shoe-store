import 'package:erp/core/mock/mock_data.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/points/data/models/points_model.dart';

abstract class IPointsRepository {
  Future<ApiResult<PointsModel>> getPoints();
  Future<ApiResult<Map<String, dynamic>>> getLoyaltySummary();
  Future<ApiResult<Map<String, dynamic>>> previewLoyalty(int points);
}

class PointsRepository extends BaseRepository implements IPointsRepository {
  PointsRepository();

  @override
  Future<ApiResult<PointsModel>> getPoints() {
    return safeApiCall<PointsModel>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.mockPoints;
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getLoyaltySummary() {
    return safeApiCall<Map<String, dynamic>>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return {
        'balance': MockData.mockPoints.balance,
        'total_earned': MockData.mockPoints.totalEarned,
        'total_used': MockData.mockPoints.totalUsed,
        'monetary_value': MockData.mockPoints.monetaryValue,
      };
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> previewLoyalty(int points) {
    return safeApiCall<Map<String, dynamic>>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return {
        'points': points,
        'value': points * 0.1,
        'message': 'يمكنك استبدال $points نقطة بقيمة ${points * 0.1} ج.م',
      };
    });
  }
}
