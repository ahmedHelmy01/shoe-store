import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';

// Feature Models
import 'package:erp/modules/webstore/admin/features/branches/data/models/branch_row.dart';
import 'package:erp/modules/webstore/admin/features/coupons/data/models/coupon_row.dart';
import 'package:erp/modules/webstore/admin/features/warehouses/data/models/warehouse_row.dart';
import 'package:erp/modules/webstore/admin/features/sliders/data/models/slider_row.dart';
import 'package:erp/modules/webstore/admin/features/ads/data/models/ad_row.dart';
import 'package:erp/modules/webstore/admin/features/boardings/data/models/boarding_row.dart';
import 'package:erp/modules/webstore/admin/features/pages/data/models/page_row.dart';
import 'package:erp/modules/webstore/admin/features/properties/data/models/property_row.dart';
import 'package:erp/modules/webstore/admin/features/payment_statuses/data/models/payment_status_row.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/data/models/payment_method_row.dart';
import 'package:erp/modules/webstore/admin/features/cities/data/models/city_row.dart';
import 'package:erp/modules/webstore/admin/features/governorates/data/models/governorate_row.dart';

abstract class IWebStoreAdminRepository {
  Future<ApiResult<AdminPagedResponse<WebStoreProduct>>> getProducts({
    int page = 1,
    String? search,
  });

  Future<ApiResult<AdminPagedResponse<BranchRow>>> getBranches({
    int page = 1,
    String? search,
  });

  Future<ApiResult<AdminPagedResponse<CouponRow>>> getCoupons({
    int page = 1,
    String? search,
  });

  Future<ApiResult<AdminPagedResponse<WarehouseRow>>> getWarehouses({
    int page = 1,
    String? search,
  });

  Future<ApiResult<AdminPagedResponse<SliderRow>>> getSliders({
    int page = 1,
    String? search,
  });

  Future<ApiResult<AdminPagedResponse<AdRow>>> getAds({
    int page = 1,
    String? search,
  });

  Future<ApiResult<AdminPagedResponse<BoardingRow>>> getBoardings({
    int page = 1,
    String? search,
  });

  Future<ApiResult<AdminPagedResponse<PageRow>>> getPages({
    int page = 1,
    String? search,
  });

  Future<ApiResult<AdminPagedResponse<PropertyRow>>> getProperties({
    int page = 1,
    String? search,
  });

  Future<ApiResult<AdminPagedResponse<PaymentStatusRow>>> getPaymentStatuses({
    int page = 1,
    String? search,
  });

  Future<ApiResult<AdminPagedResponse<PaymentMethodRow>>> getPaymentMethods({
    int page = 1,
    String? search,
  });

  Future<ApiResult<AdminPagedResponse<CityRow>>> getCities({
    int page = 1,
    String? search,
  });

  Future<ApiResult<AdminPagedResponse<GovernorateRow>>> getGovernorates({
    int page = 1,
    String? search,
  });
}

class WebStoreAdminRepository extends BaseRepository implements IWebStoreAdminRepository {
  final WebStoreAdminRemoteDataSource _ds;

  WebStoreAdminRepository(this._ds);

  AdminPagedResponse<T> _parsePaged<T>(
    Map<String, dynamic> json,
    int fallbackPage,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    var data = json['data'];

    List<dynamic> list;
    int currentPage = fallbackPage;
    int? lastPage;
    int? total;

    if (data is Map) {
      list = (data['data'] as List? ?? const <dynamic>[]);
      currentPage = (data['current_page'] as int?) ?? fallbackPage;
      lastPage = data['last_page'] as int?;
      total = data['total'] as int?;
    } else if (data is List) {
      list = data;
      final meta = json['meta'];
      if (meta is Map) {
        currentPage = (meta['current_page'] as int?) ?? fallbackPage;
        lastPage = meta['last_page'] as int?;
        total = meta['total'] as int?;
      }
    } else {
      list = const <dynamic>[];
    }

    final items = list
        .whereType<Map>()
        .map((e) => fromJson(e.cast<String, dynamic>()))
        .toList(growable: false);

    return AdminPagedResponse<T>(
      items: items,
      page: currentPage,
      lastPage: lastPage,
      total: total,
    );
  }

  @override
  Future<ApiResult<AdminPagedResponse<WebStoreProduct>>> getProducts({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getProducts(page: page, search: search);
      return _parsePaged(json, page, (j) => WebStoreProduct.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<BranchRow>>> getBranches({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getBranches(page: page, search: search);
      return _parsePaged(json, page, BranchRow.fromJson);
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<CouponRow>>> getCoupons({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getCoupons(page: page, search: search);
      return _parsePaged(json, page, CouponRow.fromJson);
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<WarehouseRow>>> getWarehouses({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getWarehouses(page: page, search: search);
      return _parsePaged(json, page, WarehouseRow.fromJson);
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<SliderRow>>> getSliders({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getSliders(page: page, search: search);
      return _parsePaged(json, page, SliderRow.fromJson);
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<AdRow>>> getAds({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getAds(page: page, search: search);
      return _parsePaged(json, page, AdRow.fromJson);
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<BoardingRow>>> getBoardings({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getBoardings(page: page, search: search);
      return _parsePaged(json, page, BoardingRow.fromJson);
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<PageRow>>> getPages({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getPages(page: page, search: search);
      return _parsePaged(json, page, PageRow.fromJson);
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<PropertyRow>>> getProperties({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getProperties(page: page, search: search);
      return _parsePaged(json, page, PropertyRow.fromJson);
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<PaymentStatusRow>>> getPaymentStatuses({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getPaymentStatuses(page: page, search: search);
      return _parsePaged(json, page, PaymentStatusRow.fromJson);
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<PaymentMethodRow>>> getPaymentMethods({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getPaymentMethods(page: page, search: search);
      return _parsePaged(json, page, PaymentMethodRow.fromJson);
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<CityRow>>> getCities({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getCities(page: page, search: search);
      return _parsePaged(json, page, CityRow.fromJson);
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<GovernorateRow>>> getGovernorates({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getGovernorates(page: page, search: search);
      return _parsePaged(json, page, GovernorateRow.fromJson);
    });
  }
}
