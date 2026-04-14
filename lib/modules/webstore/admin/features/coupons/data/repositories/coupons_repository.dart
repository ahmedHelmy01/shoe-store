import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/coupons/data/models/coupon_row.dart';

abstract class ICouponsRepository {
  Future<ApiResult<AdminPagedResponse<CouponRow>>> getCoupons({
    int page = 1,
    String? search,
  });

  Future<ApiResult<CouponRow>> saveCoupon(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteCoupon(int id);
}

class CouponsRepository extends AdminBaseRepository implements ICouponsRepository {
  final WebStoreAdminRemoteDataSource _ds;

  CouponsRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<CouponRow>>> getCoupons({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getCoupons(page: page, search: search);
      return parsePaged(json, page, (j) => CouponRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<CouponRow>> saveCoupon(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.coupons, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.coupons, id),
              data,
            );
      return parseSingle(json, (j) => CouponRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteCoupon(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.coupons, id),
      );
    });
  }
}
