import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/coupons/data/models/coupon_row.dart';

final couponsVmProvider = NotifierProvider<CouponsVm, AdminCrudState<CouponRow>>(CouponsVm.new);

class CouponsVm extends AdminCrudVm<CouponRow> {
  @override
  Future<ApiResult<AdminPagedResponse<CouponRow>>> getItems({required int page, String? search}) {
    return ref.read(webStoreAdminRepositoryProvider).getCoupons(page: page, search: search);
  }

  @override
  Future<ApiResult<CouponRow>> saveItem(Map<String, dynamic> data, {dynamic id}) {
    return ref.read(webStoreAdminRepositoryProvider).saveCoupon(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(webStoreAdminRepositoryProvider).deleteCoupon(id as int);
  }
}
