import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/admin/features/loyalty/data/datasource/loyalty_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/loyalty/data/models/loyalty_settings_model.dart';
import 'package:erp/modules/webstore/admin/features/loyalty/data/models/admin_customer_points_model.dart';
import 'package:erp/modules/webstore/admin/features/loyalty/data/models/points_report_model.dart';

abstract class ILoyaltyAdminRepository {
  Future<ApiResult<LoyaltySettingsModel>> getSettings();
  Future<ApiResult<void>> updateSettings(LoyaltySettingsModel settings);
  Future<ApiResult<AdminCustomerPointsModel>> getCustomerPoints(
      dynamic customerId);
  Future<ApiResult<void>> adjustCustomerPoints(
    dynamic customerId,
    int points,
    String reason, {
    bool isDeduct = false,
  });
  Future<ApiResult<void>> awardOrderPoints(dynamic orderId);
  Future<ApiResult<void>> cancelOrderWithPoints(dynamic orderId);
  Future<ApiResult<PointsReportModel>> getReport(
    String endpoint, {
    Map<String, dynamic>? query,
  });
}

class LoyaltyAdminRepository extends BaseRepository
    implements ILoyaltyAdminRepository {
  final LoyaltyAdminRemoteDataSource _ds;

  LoyaltyAdminRepository(this._ds);

  @override
  Future<ApiResult<LoyaltySettingsModel>> getSettings() {
    return safeApiCall(() async {
      final json = await _ds.getSettings();
      final data = json['data'] as Map<String, dynamic>? ??
          json as Map<String, dynamic>;
      return LoyaltySettingsModel.fromJson(data);
    });
  }

  @override
  Future<ApiResult<void>> updateSettings(LoyaltySettingsModel settings) {
    return safeApiCall(() async {
      await _ds.updateSettings(settings.toJson());
    });
  }

  @override
  Future<ApiResult<AdminCustomerPointsModel>> getCustomerPoints(
      dynamic customerId) {
    return safeApiCall(() async {
      final json = await _ds.getCustomerPoints(customerId);
      final data = json['data'] as Map<String, dynamic>? ??
          json as Map<String, dynamic>;
      return AdminCustomerPointsModel.fromJson(data);
    });
  }

  @override
  Future<ApiResult<void>> adjustCustomerPoints(
    dynamic customerId,
    int points,
    String reason, {
    bool isDeduct = false,
  }) {
    return safeApiCall(() async {
      await _ds.adjustCustomerPoints(customerId, {
        'points': isDeduct ? -points.abs() : points,
        'reason': reason,
      });
    });
  }

  @override
  Future<ApiResult<void>> awardOrderPoints(dynamic orderId) {
    return safeApiCall(() async {
      await _ds.awardOrderPoints(orderId);
    });
  }

  @override
  Future<ApiResult<void>> cancelOrderWithPoints(dynamic orderId) {
    return safeApiCall(() async {
      await _ds.cancelOrderWithPoints(orderId);
    });
  }

  @override
  Future<ApiResult<PointsReportModel>> getReport(
    String endpoint, {
    Map<String, dynamic>? query,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getReport(endpoint, query: query);
      final rawData = json['data'];
      final data = rawData is Map<String, dynamic>
          ? rawData
          : json as Map<String, dynamic>;
      return PointsReportModel.fromJson(data);
    });
  }
}

final loyaltyAdminRepositoryProvider = Provider<ILoyaltyAdminRepository>((ref) {
  return LoyaltyAdminRepository(
    LoyaltyAdminRemoteDataSource(ref.watch(networkServiceProvider)),
  );
});
