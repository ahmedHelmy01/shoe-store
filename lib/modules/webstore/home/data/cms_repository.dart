import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/home/data/webstore_cms_remote_datasource.dart';
import 'package:erp/modules/webstore/branches/data/branch_model.dart';
import 'package:erp/modules/webstore/home/data/models/store_settings_model.dart';
import 'package:erp/modules/webstore/support/data/models/contact_request_model.dart';
import 'package:erp/modules/webstore/home/data/models/coupon_model.dart';

abstract class ICMSRepository {
  Future<ApiResult<Map<String, dynamic>>> getSliders();
  Future<ApiResult<Map<String, dynamic>>> getAds();
  Future<ApiResult<List<StoreCouponModel>>> getCoupons();
  Future<ApiResult<Map<String, dynamic>>> getPages();
  Future<ApiResult<Map<String, dynamic>>> getPageBySlug(String slug);
  
  // ─── New Standardized Services ───────────────────────
  Future<ApiResult<List<BranchModel>>> getBranches();
  Future<ApiResult<StoreSettingsModel>> getSettings();
  Future<ApiResult<void>> submitContact(ContactRequestModel request);
}

class CMSRepository extends BaseRepository implements ICMSRepository {
  final WebStoreCmsRemoteDataSource _remoteDataSource;
  CMSRepository(this._remoteDataSource);

  @override
  Future<ApiResult<Map<String, dynamic>>> getSliders() => 
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getSliders());

  @override
  Future<ApiResult<Map<String, dynamic>>> getAds() => 
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getAds());

  @override
  Future<ApiResult<List<StoreCouponModel>>> getCoupons() =>
      safeApiCall<List<StoreCouponModel>>(() async {
        final response = await _remoteDataSource.getCoupons();
        final List<dynamic> data = response['data'] ?? [];
        return data.map((e) => StoreCouponModel.fromJson(e as Map<String, dynamic>)).toList();
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> getPages() => 
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getPages());

  @override
  Future<ApiResult<Map<String, dynamic>>> getPageBySlug(String slug) =>
      safeApiCall<Map<String, dynamic>>(() => _remoteDataSource.getPageBySlug(slug));

  @override
  Future<ApiResult<List<BranchModel>>> getBranches() =>
      safeApiCall<List<BranchModel>>(() async {
        final response = await _remoteDataSource.getBranches();
        final List<dynamic> data = response['data'] ?? [];
        return data.map((e) => BranchModel.fromJson(e as Map<String, dynamic>)).toList();
      });

  @override
  Future<ApiResult<StoreSettingsModel>> getSettings() =>
      safeApiCall<StoreSettingsModel>(() async {
        final response = await _remoteDataSource.getSettings();
        final Map<String, dynamic> data = response['data'] ?? {};
        return StoreSettingsModel.fromJson(data);
      });

  @override
  Future<ApiResult<void>> submitContact(ContactRequestModel request) =>
      safeApiCall<void>(() => _remoteDataSource.submitContact(request.toJson()));
}
