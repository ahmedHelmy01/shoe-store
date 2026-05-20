import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/points/data/datasource/points_remote_datasource.dart';
import 'package:erp/modules/webstore/points/data/repositories/points_repository.dart';
import 'package:erp/modules/webstore/points/data/models/points_model.dart';

final pointsRemoteDataSourceProvider = Provider<PointsRemoteDataSource>((ref) {
  return PointsRemoteDataSource(ref.watch(networkServiceProvider));
});

final pointsRepositoryProvider = Provider<IPointsRepository>((ref) {
  return PointsRepository(ref.watch(pointsRemoteDataSourceProvider));
});

final pointsProvider = AsyncNotifierProvider<PointsNotifier, PointsModel>(() {
  return PointsNotifier();
});

class PointsNotifier extends AsyncNotifier<PointsModel> {
  @override
  Future<PointsModel> build() async {
    return _fetchPoints();
  }

  Future<PointsModel> _fetchPoints() async {
    final repo = ref.read(pointsRepositoryProvider);
    final result = await repo.getPoints();
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure.message,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPoints());
  }
}
