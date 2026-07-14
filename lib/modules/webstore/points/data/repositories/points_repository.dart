import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/points/data/datasource/points_remote_datasource.dart';
import 'package:erp/modules/webstore/points/data/models/points_model.dart';

abstract class IPointsRepository {
  Future<ApiResult<PointsModel>> getPoints();
  Future<ApiResult<Map<String, dynamic>>> getLoyaltySummary();
  Future<ApiResult<Map<String, dynamic>>> previewLoyalty(int points);
}

class PointsRepository extends BaseRepository implements IPointsRepository {
  final PointsRemoteDataSource _dataSource;

  PointsRepository(this._dataSource);

  @override
  Future<ApiResult<PointsModel>> getPoints() {
    return safeApiCall<PointsModel>(() async {
      final response = await _dataSource.getPoints();
      final data = response['data'] ?? response;
      return PointsModel.fromJson(data as Map<String, dynamic>);
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getLoyaltySummary() {
    return safeApiCall<Map<String, dynamic>>(() async {
      final response = await _dataSource.getLoyaltySummary();
      final data = response['data'] ?? response;
      return Map<String, dynamic>.from(data as Map);
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> previewLoyalty(int points) {
    return safeApiCall<Map<String, dynamic>>(() async {
      final response = await _dataSource.previewLoyalty({'points': points});
      final data = response['data'] ?? response;
      return Map<String, dynamic>.from(data as Map);
    });
  }
}
