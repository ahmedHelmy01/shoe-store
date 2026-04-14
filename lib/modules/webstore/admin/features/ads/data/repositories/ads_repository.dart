import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/ads/data/models/ad_row.dart';

abstract class IAdsRepository {
  Future<ApiResult<AdminPagedResponse<AdRow>>> getAds({
    int page = 1,
    String? search,
  });

  Future<ApiResult<AdRow>> saveAd(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteAd(int id);
}

class AdsRepository extends AdminBaseRepository implements IAdsRepository {
  final WebStoreAdminRemoteDataSource _ds;

  AdsRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<AdRow>>> getAds({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getAds(page: page, search: search);
      return parsePaged(json, page, (j) => AdRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdRow>> saveAd(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.ads, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.ads, id),
              data,
            );
      return parseSingle(json, (j) => AdRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteAd(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.ads, id),
      );
    });
  }
}
