import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/payment_statuses/data/models/payment_status_row.dart';

final paymentStatusesVmProvider = NotifierProvider<PaymentStatusesVm, AdminCrudState<PaymentStatusRow>>(PaymentStatusesVm.new);

class PaymentStatusesVm extends AdminCrudVm<PaymentStatusRow> {
  @override
  Future<ApiResult<AdminPagedResponse<PaymentStatusRow>>> getItems({required int page, String? search}) {
    return ref.read(paymentStatusesRepositoryProvider).getPaymentStatuses(page: page, search: search);
  }

  @override
  Future<ApiResult<PaymentStatusRow>> saveItem(Map<String, dynamic> data, {dynamic id}) {
    return ref.read(paymentStatusesRepositoryProvider).savePaymentStatus(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(paymentStatusesRepositoryProvider).deletePaymentStatus(id as int);
  }
}
