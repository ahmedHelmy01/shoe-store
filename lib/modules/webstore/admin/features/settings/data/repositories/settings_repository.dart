import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/store_settings_model.dart';

class AdminSettingsRepository extends BaseRepository {
  final NetworkService _network;
  AdminSettingsRepository(this._network);

  Future<ApiResult<void>> updateSettings(StoreSettingsModel settings) async {
    final result = await safeApiCall(() async {
      await _network.put(
        ApiEndpoints.webstore.admin.settings,
        body: settings.toJson(),
      );
    });
    return result;
  }
}

final adminSettingsRepositoryProvider = Provider<AdminSettingsRepository>((ref) {
  return AdminSettingsRepository(ref.watch(networkServiceProvider));
});
