import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import '../datasource/admin_prescriptions_remote_datasource.dart';
import '../models/admin_prescription_row.dart';

abstract class IAdminPrescriptionsRepository {
  Future<ApiResult<AdminPagedResponse<AdminPrescriptionRow>>> getPrescriptions({
    int page = 1,
    String? status,
    int? customerId,
    int? perPage,
  });

  Future<ApiResult<AdminPrescriptionRow>> getPrescription(int id);

  Future<ApiResult<AdminPrescriptionRow>> reviewPrescription(int id, {required String status, String? note});
}

class AdminPrescriptionsRepository extends AdminBaseRepository implements IAdminPrescriptionsRepository {
  final AdminPrescriptionsRemoteDataSource _ds;

  AdminPrescriptionsRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<AdminPrescriptionRow>>> getPrescriptions({
    int page = 1,
    String? status,
    int? customerId,
    int? perPage,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getPrescriptions(
        page: page,
        status: status,
        customerId: customerId,
        perPage: perPage,
      );
      return parsePaged(json, page, (j) => AdminPrescriptionRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPrescriptionRow>> getPrescription(int id) {
    return safeApiCall(() async {
      final json = await _ds.getPrescription(id);
      return parseSingle(json, (j) => AdminPrescriptionRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPrescriptionRow>> reviewPrescription(int id, {required String status, String? note}) {
    return safeApiCall(() async {
      final data = {
        'status': status,
        'note': ?note,
      };
      final json = await _ds.reviewPrescription(id, data);
      return parseSingle(json, (j) => AdminPrescriptionRow.fromJson(j));
    });
  }
}
