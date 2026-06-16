import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import '../../data/models/admin_prescription_row.dart';

final adminPrescriptionsVmProvider = NotifierProvider.autoDispose<AdminPrescriptionsVm, AdminCrudState<AdminPrescriptionRow>>(AdminPrescriptionsVm.new);

class AdminPrescriptionsVm extends AdminCrudVm<AdminPrescriptionRow> {
  String? _statusFilter;
  int? _customerFilter;

  void setFilters({String? status, int? customerId}) {
    _statusFilter = status;
    _customerFilter = customerId;
    fetch(page: 1);
  }

  @override
  Future<ApiResult<AdminPagedResponse<AdminPrescriptionRow>>> getItems({required int page, String? search, int? perPage}) {
    // Note: search isn't directly supported by this API yet, but we'll use filters
    return ref.read(adminPrescriptionsRepositoryProvider).getPrescriptions(
      page: page,
      status: _statusFilter,
      customerId: _customerFilter,
      perPage: perPage,
    );
  }

  @override
  Future<ApiResult<AdminPrescriptionRow>> saveItem(
    Map<String, dynamic> data, {
    dynamic id,
    XFile? imageFile,
    Map<String, dynamic>? extraData,
    void Function(double)? onProgress,
  }) {
    // In this module, "saving" is actually "reviewing"
    return ref.read(adminPrescriptionsRepositoryProvider).reviewPrescription(
      id as int,
      status: data['status'] as String,
      note: data['note'] as String?,
    );
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    // No delete service mentioned for admin prescriptions, but we'll leave it for CRUD compatibility if needed.
    // Return a dummy success if not applicable.
    return Future.value(const ApiSuccess<void>(null));
  }
}
