import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/data/models/payment_method_row.dart';

final paymentMethodsVmProvider = NotifierProvider<PaymentMethodsVm, AdminCrudState<PaymentMethodRow>>(PaymentMethodsVm.new);

class PaymentMethodsVm extends AdminCrudVm<PaymentMethodRow> {
  @override
  Future<ApiResult<AdminPagedResponse<PaymentMethodRow>>> getItems({required int page, String? search}) {
    return ref.read(webStoreAdminRepositoryProvider).getPaymentMethods(page: page, search: search);
  }

  @override
  Future<ApiResult<PaymentMethodRow>> saveItem(Map<String, dynamic> data, {dynamic id}) {
    return ref.read(webStoreAdminRepositoryProvider).savePaymentMethod(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(webStoreAdminRepositoryProvider).deletePaymentMethod(id as int);
  }
}
