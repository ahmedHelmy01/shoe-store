import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

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
import 'package:erp/modules/webstore/admin/features/catalog/categories/data/models/category_row.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/models/product_row.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/data/models/filter_row.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/data/models/company_row.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';
import 'package:erp/modules/webstore/admin/features/users/data/models/user_row.dart';

abstract class IWebStoreAdminRepository {
  Future<ApiResult<AdminPagedResponse<ProductRow>>> getProducts({
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

  Future<ApiResult<AdminPagedResponse<CategoryRow>>> getCategories({
    int page = 1,
    String? search,
  });

  Future<ApiResult<AdminPagedResponse<FilterRow>>> getFilters({
    int page = 1,
    String? search,
  });

  Future<ApiResult<AdminPagedResponse<CompanyRow>>> getCompanies({
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

  Future<ApiResult<AdminPagedResponse<OrderRow>>> getOrders({
    int page = 1,
    String? search,
  });

  Future<ApiResult<AdminPagedResponse<UserRow>>> getClients({
    int page = 1,
    String? search,
  });

  // ─── Ads CRUD ────────────────────────────────────
  Future<ApiResult<AdRow>> saveAd(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteAd(int id);

  // ─── Sliders CRUD ────────────────────────────────
  Future<ApiResult<SliderRow>> saveSlider(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteSlider(int id);

  // ─── Boardings CRUD ──────────────────────────────
  Future<ApiResult<BoardingRow>> saveBoarding(
    Map<String, dynamic> data, {
    int? id,
  });

  Future<ApiResult<void>> deleteBoarding(int id);

  // ─── Cities CRUD ─────────────────────────────────
  Future<ApiResult<CityRow>> saveCity(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteCity(int id);

  // ─── Governorates CRUD ───────────────────────────
  Future<ApiResult<GovernorateRow>> saveGovernorate(
    Map<String, dynamic> data, {
    int? id,
  });

  Future<ApiResult<void>> deleteGovernorate(int id);

  // ─── Payment Methods CRUD ────────────────────────
  Future<ApiResult<PaymentMethodRow>> savePaymentMethod(
    Map<String, dynamic> data, {
    int? id,
  });

  Future<ApiResult<void>> deletePaymentMethod(int id);

  // ─── Payment Statuses CRUD ───────────────────────
  Future<ApiResult<PaymentStatusRow>> savePaymentStatus(
    Map<String, dynamic> data, {
    int? id,
  });

  Future<ApiResult<void>> deletePaymentStatus(int id);

  // ─── Branches CRUD ───────────────────────────────
  Future<ApiResult<BranchRow>> saveBranch(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteBranch(int id);

  // ─── Warehouses CRUD ─────────────────────────────
  Future<ApiResult<WarehouseRow>> saveWarehouse(
    Map<String, dynamic> data, {
    int? id,
  });

  Future<ApiResult<void>> deleteWarehouse(int id);

  // ─── Companies CRUD ──────────────────────────────
  Future<ApiResult<CompanyRow>> saveCompany(
    Map<String, dynamic> data, {
    int? id,
  });

  Future<ApiResult<void>> deleteCompany(int id);

  // ─── Properties CRUD ─────────────────────────────
  Future<ApiResult<PropertyRow>> saveProperty(
    Map<String, dynamic> data, {
    int? id,
  });

  Future<ApiResult<void>> deleteProperty(int id);

  // ─── Pages CRUD ──────────────────────────────────
  Future<ApiResult<PageRow>> savePage(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deletePage(int id);

  // ─── Categories CRUD ─────────────────────────────
  Future<ApiResult<CategoryRow>> saveCategory(
    Map<String, dynamic> data, {
    int? id,
  });

  Future<ApiResult<void>> deleteCategory(int id);

  // ─── Filters CRUD ────────────────────────────────
  Future<ApiResult<FilterRow>> saveFilter(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteFilter(int id);

  // ─── Products CRUD ───────────────────────────────
  Future<ApiResult<ProductRow>> saveProduct(
    Map<String, dynamic> data, {
    int? id,
  });

  Future<ApiResult<void>> deleteProduct(int id);

  // ─── Coupons CRUD ────────────────────────────────
  Future<ApiResult<CouponRow>> saveCoupon(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteCoupon(int id);

  // ─── Orders CRUD ─────────────────────────────────
  Future<ApiResult<OrderRow>> saveOrder(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteOrder(int id);
}

class WebStoreAdminRepository extends BaseRepository
    implements IWebStoreAdminRepository {
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

  T _parseSingle<T>(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    // If encapsulated in data
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return fromJson(data);
  }

  @override
  Future<ApiResult<AdminPagedResponse<ProductRow>>> getProducts({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getProducts(page: page, search: search);
      return _parsePaged(json, page, (j) => ProductRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<BranchRow>>> getBranches({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getBranches(page: page, search: search);
      return _parsePaged(json, page, (j) => BranchRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<CouponRow>>> getCoupons({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getCoupons(page: page, search: search);
      return _parsePaged(json, page, (j) => CouponRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<WarehouseRow>>> getWarehouses({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getWarehouses(page: page, search: search);
      return _parsePaged(json, page, (j) => WarehouseRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<SliderRow>>> getSliders({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getSliders(page: page, search: search);
      return _parsePaged(json, page, (j) => SliderRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<AdRow>>> getAds({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getAds(page: page, search: search);
      return _parsePaged(json, page, (j) => AdRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<BoardingRow>>> getBoardings({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getBoardings(page: page, search: search);
      return _parsePaged(json, page, (j) => BoardingRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<PageRow>>> getPages({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getPages(page: page, search: search);
      return _parsePaged(json, page, (j) => PageRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<PropertyRow>>> getProperties({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getProperties(page: page, search: search);
      return _parsePaged(json, page, (j) => PropertyRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<PaymentStatusRow>>> getPaymentStatuses({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getPaymentStatuses(page: page, search: search);
      return _parsePaged(json, page, (j) => PaymentStatusRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<PaymentMethodRow>>> getPaymentMethods({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getPaymentMethods(page: page, search: search);
      return _parsePaged(json, page, (j) => PaymentMethodRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<CityRow>>> getCities({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getCities(page: page, search: search);
      return _parsePaged(json, page, (j) => CityRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<GovernorateRow>>> getGovernorates({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getGovernorates(page: page, search: search);
      return _parsePaged(json, page, (j) => GovernorateRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<CategoryRow>>> getCategories({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getCategories(page: page, search: search);
      return _parsePaged(json, page, (j) => CategoryRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<FilterRow>>> getFilters({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getFilters(page: page, search: search);
      return _parsePaged(json, page, (j) => FilterRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<CompanyRow>>> getCompanies({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getCompanies(page: page, search: search);
      return _parsePaged(json, page, (j) => CompanyRow.fromJson(j));
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
      return _parseSingle(json, (j) => AdRow.fromJson(j));
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

  // ─── Sliders ────────────────────────────────────
  @override
  Future<ApiResult<SliderRow>> saveSlider(
    Map<String, dynamic> data, {
    int? id,
  }) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.sliders, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.sliders, id),
              data,
            );
      return _parseSingle(json, (j) => SliderRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteSlider(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.sliders, id),
      );
    });
  }

  // ─── Boardings ──────────────────────────────────
  @override
  Future<ApiResult<BoardingRow>> saveBoarding(
    Map<String, dynamic> data, {
    int? id,
  }) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.boardings, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.boardings, id),
              data,
            );
      return _parseSingle(json, (j) => BoardingRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteBoarding(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.boardings, id),
      );
    });
  }

  // ─── Cities ─────────────────────────────────────
  @override
  Future<ApiResult<CityRow>> saveCity(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.cities, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.cities, id),
              data,
            );
      return _parseSingle(json, (j) => CityRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteCity(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.cities, id),
      );
    });
  }

  // ─── Governorates ───────────────────────────────
  @override
  Future<ApiResult<GovernorateRow>> saveGovernorate(
    Map<String, dynamic> data, {
    int? id,
  }) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.governorates, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.governorates, id),
              data,
            );
      return _parseSingle(json, (j) => GovernorateRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteGovernorate(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.governorates, id),
      );
    });
  }

  // ─── Payment Methods ────────────────────────────
  @override
  Future<ApiResult<PaymentMethodRow>> savePaymentMethod(
    Map<String, dynamic> data, {
    int? id,
  }) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.paymentMethods, data)
          : await _ds.putData(
              ApiEndpoints.withId(
                ApiEndpoints.webstore.admin.paymentMethods,
                id,
              ),
              data,
            );
      return _parseSingle(json, (j) => PaymentMethodRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deletePaymentMethod(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.paymentMethods, id),
      );
    });
  }

  // ─── Payment Statuses ───────────────────────────
  @override
  Future<ApiResult<PaymentStatusRow>> savePaymentStatus(
    Map<String, dynamic> data, {
    int? id,
  }) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(
              ApiEndpoints.webstore.admin.paymentStatuses,
              data,
            )
          : await _ds.putData(
              ApiEndpoints.withId(
                ApiEndpoints.webstore.admin.paymentStatuses,
                id,
              ),
              data,
            );
      return _parseSingle(json, (j) => PaymentStatusRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deletePaymentStatus(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.paymentStatuses, id),
      );
    });
  }

  // ─── Branches ────────────────────────────────────
  @override
  Future<ApiResult<BranchRow>> saveBranch(
    Map<String, dynamic> data, {
    int? id,
  }) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.branches, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.branches, id),
              data,
            );
      return _parseSingle(json, (j) => BranchRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteBranch(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.branches, id),
      );
    });
  }

  // ─── Warehouses ──────────────────────────────────
  @override
  Future<ApiResult<WarehouseRow>> saveWarehouse(
    Map<String, dynamic> data, {
    int? id,
  }) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.warehouses, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.warehouses, id),
              data,
            );
      return _parseSingle(json, (j) => WarehouseRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteWarehouse(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.warehouses, id),
      );
    });
  }

  // ─── Companies ───────────────────────────────────
  @override
  Future<ApiResult<CompanyRow>> saveCompany(
    Map<String, dynamic> data, {
    int? id,
  }) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.companies, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.companies, id),
              data,
            );
      return _parseSingle(json, (j) => CompanyRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteCompany(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.companies, id),
      );
    });
  }

  // ─── Properties ──────────────────────────────────
  @override
  Future<ApiResult<PropertyRow>> saveProperty(
    Map<String, dynamic> data, {
    int? id,
  }) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.properties, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.properties, id),
              data,
            );
      return _parseSingle(json, (j) => PropertyRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteProperty(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.properties, id),
      );
    });
  }

  // ─── Pages ───────────────────────────────────────
  @override
  Future<ApiResult<PageRow>> savePage(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.pages, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.pages, id),
              data,
            );
      return _parseSingle(json, (j) => PageRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deletePage(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.pages, id),
      );
    });
  }

  // ─── Categories ──────────────────────────────────
  @override
  Future<ApiResult<CategoryRow>> saveCategory(
    Map<String, dynamic> data, {
    int? id,
  }) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.categories, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.categories, id),
              data,
            );
      return _parseSingle(json, (j) => CategoryRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteCategory(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.categories, id),
      );
    });
  }

  // ─── Filters ─────────────────────────────────────
  @override
  Future<ApiResult<FilterRow>> saveFilter(
    Map<String, dynamic> data, {
    int? id,
  }) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.filters, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.filters, id),
              data,
            );
      return _parseSingle(json, (j) => FilterRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteFilter(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.filters, id),
      );
    });
  }

  // ─── Products ────────────────────────────────────
  @override
  Future<ApiResult<ProductRow>> saveProduct(
    Map<String, dynamic> data, {
    int? id,
  }) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.products, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.products, id),
              data,
            );
      return _parseSingle(json, (j) => ProductRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteProduct(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.products, id),
      );
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<OrderRow>>> getOrders({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getOrders(page: page, search: search);
      return _parsePaged(json, page, (j) => OrderRow.fromJson(j));
    });
  }

  // ─── Coupons ─────────────────────────────────────
  @override
  Future<ApiResult<CouponRow>> saveCoupon(
    Map<String, dynamic> data, {
    int? id,
  }) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.coupons, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.coupons, id),
              data,
            );
      return _parseSingle(json, (j) => CouponRow.fromJson(j));
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

  // ─── Orders ──────────────────────────────────────
  @override
  Future<ApiResult<OrderRow>> saveOrder(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.orders, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.orders, id),
              data,
            );
      return _parseSingle(json, (j) => OrderRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteOrder(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.orders, id),
      );
    });
  }

  @override
  Future<ApiResult<AdminPagedResponse<UserRow>>> getClients({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getClients(page: page, search: search);
      return _parsePaged(json, page, (j) => UserRow.fromJson(j));
    });
  }
}
