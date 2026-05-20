import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/points/data/datasource/points_remote_datasource.dart';
import 'package:erp/modules/webstore/points/data/models/points_model.dart';

abstract class IPointsRepository {
  Future<ApiResult<PointsModel>> getPoints();
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
}
