import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/data/models/payment_method_row.dart';

final paymentMethodsVmProvider = NotifierProvider.autoDispose<PaymentMethodsVm, AdminCrudState<PaymentMethodRow>>(PaymentMethodsVm.new);

class PaymentMethodsVm extends AdminCrudVm<PaymentMethodRow> {
  @override
  Future<ApiResult<AdminPagedResponse<PaymentMethodRow>>> getItems({required int page, String? search, int? perPage}) {
    return ref.read(paymentMethodsRepositoryProvider).getPaymentMethods(page: page, search: search);
  }

  @override
  Future<ApiResult<PaymentMethodRow>> saveItem(Map<String, dynamic> data, {dynamic id, XFile? imageFile, Map<String, dynamic>? extraData, void Function(double)? onProgress}) {
    return ref.read(paymentMethodsRepositoryProvider).savePaymentMethod(data, id: id as int?, imageFile: imageFile);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(paymentMethodsRepositoryProvider).deletePaymentMethod(id as int);
  }
}
