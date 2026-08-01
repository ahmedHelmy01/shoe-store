import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/home/data/models/store_settings_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storeSettingsProvider = FutureProvider<StoreSettingsModel?>((ref) async {
  final network = ref.watch(networkServiceProvider);
  final res = await network.get(ApiEndpoints.webstore.cms.settings);
  final json = res as Map<String, dynamic>;
  final data = json['data'] as Map<String, dynamic>? ?? json;
  return StoreSettingsModel.fromJson(data);
});
