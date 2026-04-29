import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/providers/core_providers.dart';
import '../models/admin_statistics_model.dart';

class AdminDashboardRepository {
  final NetworkService _network;

  AdminDashboardRepository(this._network);

  Future<AdminStatisticsModel> getStatistics() async {
    final response = await _network.get('/api/store/admin/statistics');
    return AdminStatisticsModel.fromJson(response);
  }
}

final adminDashboardRepositoryProvider = Provider<AdminDashboardRepository>((ref) {
  return AdminDashboardRepository(ref.watch(networkServiceProvider));
});
