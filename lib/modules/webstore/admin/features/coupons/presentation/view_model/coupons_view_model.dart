import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/coupons/data/models/coupon_row.dart';

final couponsVmProvider = NotifierProvider<CouponsVm, AdminCrudState<CouponRow>>(CouponsVm.new);

class CouponsVm extends AdminCrudVm<CouponRow> {
  @override
  Future<ApiResult<AdminPagedResponse<CouponRow>>> getItems({required int page, String? search, int? perPage}) {
    return ref.read(couponsRepositoryProvider).getCoupons(page: page, search: search);
  }

  @override
  Future<ApiResult<CouponRow>> saveItem(Map<String, dynamic> data, {dynamic id, XFile? imageFile, Map<String, dynamic>? extraData, void Function(double)? onProgress}) {
    return ref.read(couponsRepositoryProvider).saveCoupon(data, id: id as int?, imageFile: imageFile);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(couponsRepositoryProvider).deleteCoupon(id as int);
  }
}
