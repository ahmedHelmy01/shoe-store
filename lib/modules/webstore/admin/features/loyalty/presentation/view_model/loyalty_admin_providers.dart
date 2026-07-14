import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/features/loyalty/data/models/loyalty_settings_model.dart';
import 'package:erp/modules/webstore/admin/features/loyalty/data/models/admin_customer_points_model.dart';
import 'package:erp/modules/webstore/admin/features/loyalty/data/models/points_report_model.dart';
import 'package:erp/modules/webstore/admin/features/loyalty/data/repositories/loyalty_admin_repository.dart';

final loyaltySettingsProvider = FutureProvider<LoyaltySettingsModel>((ref) async {
  final repo = ref.watch(loyaltyAdminRepositoryProvider);
  final result = await repo.getSettings();
  return result.when(
    success: (data) => data,
    failure: (e) => throw e,
  );
});

enum SaveStatus { idle, saving, success, error }

class UpdateLoyaltySettingsState {
  final SaveStatus status;
  final String? error;

  const UpdateLoyaltySettingsState({this.status = SaveStatus.idle, this.error});
}

class UpdateLoyaltySettingsNotifier extends Notifier<UpdateLoyaltySettingsState> {
  @override
  UpdateLoyaltySettingsState build() => const UpdateLoyaltySettingsState();

  Future<void> updateSettings(LoyaltySettingsModel settings) async {
    state = const UpdateLoyaltySettingsState(status: SaveStatus.saving);
    final repo = ref.read(loyaltyAdminRepositoryProvider);
    final result = await repo.updateSettings(settings);
    result.when(
      success: (_) => state = const UpdateLoyaltySettingsState(status: SaveStatus.success),
      failure: (e) => state = UpdateLoyaltySettingsState(status: SaveStatus.error, error: e.message),
    );
  }

  void reset() => state = const UpdateLoyaltySettingsState();
}

final updateLoyaltySettingsProvider = NotifierProvider<UpdateLoyaltySettingsNotifier, UpdateLoyaltySettingsState>(
  UpdateLoyaltySettingsNotifier.new,
);

final customerPointsProvider = FutureProvider.family<AdminCustomerPointsModel, dynamic>((ref, customerId) async {
  final repo = ref.watch(loyaltyAdminRepositoryProvider);
  final result = await repo.getCustomerPoints(customerId);
  return result.when(
    success: (data) => data,
    failure: (e) => throw e,
  );
});

class AdjustCustomerPointsNotifier extends Notifier<UpdateLoyaltySettingsState> {
  @override
  UpdateLoyaltySettingsState build() => const UpdateLoyaltySettingsState();

  Future<void> adjust(dynamic customerId, int points, String reason, bool isDeduct) async {
    state = const UpdateLoyaltySettingsState(status: SaveStatus.saving);
    final repo = ref.read(loyaltyAdminRepositoryProvider);
    final result = await repo.adjustCustomerPoints(customerId, points, reason, isDeduct: isDeduct);
    result.when(
      success: (_) => state = const UpdateLoyaltySettingsState(status: SaveStatus.success),
      failure: (e) => state = UpdateLoyaltySettingsState(status: SaveStatus.error, error: e.message),
    );
  }

  void reset() => state = const UpdateLoyaltySettingsState();
}

final adjustCustomerPointsProvider = NotifierProvider<AdjustCustomerPointsNotifier, UpdateLoyaltySettingsState>(
  AdjustCustomerPointsNotifier.new,
);

class AwardOrderPointsNotifier extends Notifier<UpdateLoyaltySettingsState> {
  @override
  UpdateLoyaltySettingsState build() => const UpdateLoyaltySettingsState();

  Future<void> award(dynamic orderId) async {
    state = const UpdateLoyaltySettingsState(status: SaveStatus.saving);
    final repo = ref.read(loyaltyAdminRepositoryProvider);
    final result = await repo.awardOrderPoints(orderId);
    result.when(
      success: (_) => state = const UpdateLoyaltySettingsState(status: SaveStatus.success),
      failure: (e) => state = UpdateLoyaltySettingsState(status: SaveStatus.error, error: e.message),
    );
  }

  Future<void> cancel(dynamic orderId) async {
    state = const UpdateLoyaltySettingsState(status: SaveStatus.saving);
    final repo = ref.read(loyaltyAdminRepositoryProvider);
    final result = await repo.cancelOrderWithPoints(orderId);
    result.when(
      success: (_) => state = const UpdateLoyaltySettingsState(status: SaveStatus.success),
      failure: (e) => state = UpdateLoyaltySettingsState(status: SaveStatus.error, error: e.message),
    );
  }

  void reset() => state = const UpdateLoyaltySettingsState();
}

final awardOrderPointsProvider = NotifierProvider<AwardOrderPointsNotifier, UpdateLoyaltySettingsState>(
  AwardOrderPointsNotifier.new,
);

final reportProvider = FutureProvider.family<PointsReportModel, String>((ref, endpoint) async {
  final repo = ref.watch(loyaltyAdminRepositoryProvider);
  final result = await repo.getReport(endpoint);
  return result.when(
    success: (data) => data,
    failure: (e) => throw e,
  );
});
