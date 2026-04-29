import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/store_settings_model.dart';

class AdminSettingsRepository {
  final NetworkService _network;
  AdminSettingsRepository(this._network);

  Future<void> updateSettings(StoreSettingsModel settings) async {
    await _network.put(
      '/api/store/admin/settings',
      body: settings.toJson(),
    );
  }
}

final adminSettingsRepositoryProvider = Provider<AdminSettingsRepository>((ref) {
  return AdminSettingsRepository(ref.watch(networkServiceProvider));
});
