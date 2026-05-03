import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/payment_statuses/data/datasource/payment_statuses_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/payment_statuses/data/models/payment_status_row.dart';

abstract class IPaymentStatusesRepository {
  Future<ApiResult<AdminPagedResponse<PaymentStatusRow>>> getPaymentStatuses({
    int page = 1,
    String? search,
  });

  Future<ApiResult<PaymentStatusRow>> savePaymentStatus(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deletePaymentStatus(int id);
}

class PaymentStatusesRepository extends AdminBaseRepository implements IPaymentStatusesRepository {
  final PaymentStatusesRemoteDataSource _ds;

  PaymentStatusesRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<PaymentStatusRow>>> getPaymentStatuses({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getPaymentStatuses(page: page, search: search);
      return parsePaged(json, page, (j) => PaymentStatusRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<PaymentStatusRow>> savePaymentStatus(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.paymentStatuses, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.paymentStatuses, id),
              data,
            );
      return parseSingle(json, (j) => PaymentStatusRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deletePaymentStatus(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.paymentStatuses, id),
      );
    });
  }
}
