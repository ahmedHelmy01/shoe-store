import 'package:erp/core/mock/mock_data.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/branches/data/branch_model.dart';
import 'package:erp/modules/webstore/home/data/models/store_settings_model.dart';
import 'package:erp/modules/webstore/support/data/models/contact_request_model.dart';
import 'package:erp/modules/webstore/home/data/models/coupon_model.dart';
import 'package:erp/modules/webstore/home/data/models/store_offer_model.dart';

abstract class ICMSRepository {
  Future<ApiResult<Map<String, dynamic>>> getSliders();
  Future<ApiResult<Map<String, dynamic>>> getAds();
  Future<ApiResult<List<StoreCouponModel>>> getCoupons();
  Future<ApiResult<List<StoreOfferModel>>> getOffers();
  Future<ApiResult<Map<String, dynamic>>> getPages();
  Future<ApiResult<Map<String, dynamic>>> getPageBySlug(String slug);
  Future<ApiResult<List<BranchModel>>> getBranches();
  Future<ApiResult<StoreSettingsModel>> getSettings();
  Future<ApiResult<void>> submitContact(ContactRequestModel request);
}

class CMSRepository extends BaseRepository implements ICMSRepository {
  CMSRepository();

  @override
  Future<ApiResult<Map<String, dynamic>>> getSliders() =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {
          'data': MockData.mockSliders.map((e) => e.toJson()).toList(),
        };
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> getAds() =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {
          'data': MockData.mockAds.map((e) => e.toJson()).toList(),
        };
      });

  @override
  Future<ApiResult<List<StoreCouponModel>>> getCoupons() =>
      safeApiCall<List<StoreCouponModel>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return MockData.mockCoupons;
      });

  @override
  Future<ApiResult<List<StoreOfferModel>>> getOffers() =>
      safeApiCall<List<StoreOfferModel>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return MockData.mockOffers;
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> getPages() =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {
          'data': MockData.mockPages.map((e) => e.toJson()).toList(),
        };
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> getPageBySlug(String slug) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        final page = MockData.mockPages.firstWhere(
          (p) => p.slug == slug,
          orElse: () => MockData.mockPages.first,
        );
        return {'data': page.toJson()};
      });

  @override
  Future<ApiResult<List<BranchModel>>> getBranches() =>
      safeApiCall<List<BranchModel>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return MockData.mockBranches;
      });

  @override
  Future<ApiResult<StoreSettingsModel>> getSettings() =>
      safeApiCall<StoreSettingsModel>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return MockData.mockSettings;
      });

  @override
  Future<ApiResult<void>> submitContact(ContactRequestModel request) =>
      safeApiCall<void>(() async {
        await Future.delayed(const Duration(milliseconds: 500));
      });
}
