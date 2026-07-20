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

final _useMockReports = false;

final reportProvider = FutureProvider.family<PointsReportModel, String>((ref, endpoint) async {
  if (_useMockReports) {
    return _mockReport(endpoint);
  }
  final repo = ref.watch(loyaltyAdminRepositoryProvider);
  final result = await repo.getReport(endpoint);
  return result.when(
    success: (data) => data,
    failure: (e) => throw e,
  );
});

PointsReportModel _mockReport(String endpoint) {
  if (endpoint.contains('balances')) {
    return PointsReportModel(
      totalPoints: 125000,
      totalValue: 12500.00,
      customerCount: 89,
      transactionCount: 1243,
      rows: List.generate(20, (i) => {
        'customer_name': 'عميل ${i + 1}',
        'balance': '${(i + 1) * 150}',
        'earned': '${(i + 1) * 320}',
        'used': '${(i + 1) * 100}',
        'expired': '${i * 20}',
        'value': '${(i + 1) * 15.0}',
      }),
    );
  }
  if (endpoint.contains('movement')) {
    return PointsReportModel(
      totalPoints: 45200,
      totalValue: 4520.00,
      customerCount: 67,
      transactionCount: 892,
      rows: List.generate(20, (i) => {
        'created_at': '2025-${(i % 12) + 1}-${(i % 28) + 1}',
        'customer_name': 'عميل ${i + 1}',
        'type': i % 3 == 0 ? 'اكتساب' : i % 3 == 1 ? 'استخدام' : 'انتهاء',
        'points': '${(i + 1) * 50}',
        'reason': i % 2 == 0 ? 'شراء' : 'مكافأة',
        'order_id': '#${1000 + i}',
      }),
    );
  }
  if (endpoint.contains('redemptions')) {
    return PointsReportModel(
      totalPoints: 32000,
      totalValue: 3200.00,
      customerCount: 45,
      transactionCount: 678,
      rows: List.generate(15, (i) => {
        'customer_name': 'عميل ${i + 1}',
        'date': '2025-${(i % 12) + 1}-${(i % 28) + 1}',
        'points': '${(i + 1) * 80}',
        'value': '${(i + 1) * 8.0}',
        'order': '#${2000 + i}',
      }),
    );
  }
  if (endpoint.contains('earned')) {
    return PointsReportModel(
      totalPoints: 98000,
      totalValue: 9800.00,
      customerCount: 78,
      transactionCount: 1560,
      rows: List.generate(18, (i) => {
        'customer_name': 'عميل ${i + 1}',
        'points': '${(i + 1) * 200}',
        'value': '${(i + 1) * 20.0}',
        'orders': '${i + 1}',
        'source': i % 2 == 0 ? 'شراء' : 'مكافأة',
      }),
    );
  }
  if (endpoint.contains('expired')) {
    return PointsReportModel(
      totalPoints: 8500,
      totalValue: 850.00,
      customerCount: 34,
      transactionCount: 210,
      rows: List.generate(12, (i) => {
        'customer_name': 'عميل ${i + 1}',
        'points': '${(i + 1) * 60}',
        'value': '${(i + 1) * 6.0}',
        'expiry_date': '2025-${(i % 12) + 1}-${(i % 28) + 1}',
      }),
    );
  }
  if (endpoint.contains('top')) {
    return PointsReportModel(
      totalPoints: 85000,
      totalValue: 8500.00,
      customerCount: 50,
      transactionCount: 980,
      rows: List.generate(15, (i) => {
        'customer_name': 'عميل ${i + 1}',
        'earned': '${(i + 1) * 500}',
        'used': '${(i + 1) * 150}',
        'expired': '${i * 30}',
        'balance': '${(i + 1) * 350}',
        'value': '${(i + 1) * 35.0}',
      }),
    );
  }
  if (endpoint.contains('cost')) {
    return PointsReportModel(
      totalPoints: 62500,
      totalValue: 6250.00,
      customerCount: 1,
      transactionCount: 12,
      rows: List.generate(12, (i) => {
        'metric': ['إجمالي النقاط الممنوحة', 'إجمالي الخصم', 'متوسط الخصم لكل طلب', 'تكلفة العميل'][i % 4],
        'value': ['62,500', '6,250.00 ر.س', '52.08 ر.س', '125.00 ر.س'][i % 4],
      }),
    );
  }
  return PointsReportModel(
    totalPoints: 0,
    totalValue: 0,
    customerCount: 0,
    transactionCount: 0,
    rows: const [],
  );
}
