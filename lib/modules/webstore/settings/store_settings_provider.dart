import 'package:erp/core/mock/mock_data.dart';
import 'package:erp/modules/webstore/home/data/models/store_settings_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storeSettingsProvider = FutureProvider<StoreSettingsModel?>((ref) async {
  return MockData.mockSettings;
});
