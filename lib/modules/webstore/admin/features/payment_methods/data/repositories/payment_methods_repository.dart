import 'package:image_picker/image_picker.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/data/datasource/payment_methods_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/data/models/payment_method_row.dart';

abstract class IPaymentMethodsRepository {
  Future<ApiResult<AdminPagedResponse<PaymentMethodRow>>> getPaymentMethods({
    int page = 1,
    String? search,
  });

  Future<ApiResult<PaymentMethodRow>> savePaymentMethod(Map<String, dynamic> data, {int? id, XFile? imageFile, void Function(double)? onProgress});

  Future<ApiResult<void>> deletePaymentMethod(int id);

  Future<ApiResult<List<Map<String, dynamic>>>> getPaymentMethodTypes();
}

class PaymentMethodsRepository extends AdminBaseRepository implements IPaymentMethodsRepository {
  final PaymentMethodsRemoteDataSource _ds;

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
  Future<ApiResult<PaymentMethodRow>> savePaymentMethod(Map<String, dynamic> data, {int? id, XFile? imageFile, void Function(double)? onProgress}) {
    return safeApiCall(() async {
      final path = id == null
          ? ApiEndpoints.webstore.admin.paymentMethods
          : ApiEndpoints.withId(ApiEndpoints.webstore.admin.paymentMethods, id);

      final Map<String, dynamic> json;
      if (imageFile != null) {
        final fields = toMultipartFields(data);
        json = id == null
            ? await _ds.postMultipart(path, fields: fields, files: {'image': imageFile}, onProgress: onProgress)
            : await _ds.putMultipart(path, fields: fields, files: {'image': imageFile}, onProgress: onProgress);
      } else {
        json = id == null ? await _ds.postData(path, data) : await _ds.putData(path, data);
      }
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

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getPaymentMethodTypes() {
    return safeApiCall(() async {
      final list = await _ds.getPaymentMethodTypes();
      return list.map((e) => (e as Map).cast<String, dynamic>()).toList();
    });
  }
}
