import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/data/models/payment_method_row.dart';

abstract class IPaymentMethodsRepository {
  Future<ApiResult<AdminPagedResponse<PaymentMethodRow>>> getPaymentMethods({
    int page = 1,
    String? search,
  });

  Future<ApiResult<PaymentMethodRow>> savePaymentMethod(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deletePaymentMethod(int id);
}

class PaymentMethodsRepository extends AdminBaseRepository implements IPaymentMethodsRepository {
  final WebStoreAdminRemoteDataSource _ds;

  PaymentMethodsRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<PaymentMethodRow>>> getPaymentMethods({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getPaymentMethods(page: page, search: search);
      return parsePaged(json, page, (j) => PaymentMethodRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<PaymentMethodRow>> savePaymentMethod(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.paymentMethods, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.paymentMethods, id),
              data,
            );
      return parseSingle(json, (j) => PaymentMethodRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deletePaymentMethod(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.paymentMethods, id),
      );
    });
  }
}
