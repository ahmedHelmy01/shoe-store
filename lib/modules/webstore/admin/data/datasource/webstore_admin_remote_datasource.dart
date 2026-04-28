import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/auth/data/models/admin_user.dart';

class WebStoreAdminRemoteDataSource {
  final NetworkService _network;


  WebStoreAdminRemoteDataSource(this._network);

  Future<AdminUser> login(String email, String password) async {
    final res = await _network.post(
      ApiEndpoints.auth.login,
      body: {
        'email': email,
        'password': password,
      },
    );
    final data = (res as Map<String, dynamic>)['data'];
    final token = (res)['token'] as String;
    return AdminUser.fromJson(data).copyWith(token: token);
  }

  Future<Map<String, dynamic>> getProducts({
    int page = 1,
    String? search,
    int? perPage,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.products,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (perPage != null) 'per_page': perPage,
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getBranches({
    int page = 1,
    String? search,
    int? perPage,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.branches,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (perPage != null) 'per_page': perPage,
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getCoupons({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.coupons,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getWarehouses({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.warehouses,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getSliders({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.sliders,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getAds({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.ads,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getBoardings({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.boardings,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getPages({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.pages,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getProperties({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.properties,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getOrderStatuses({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.orderStatuses,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getCustomerGroups({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.customerGroups,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getPaymentStatuses({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.paymentStatuses,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getPaymentMethods({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.paymentMethods,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getCities({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.cities,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getGovernorates({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.governorates,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getCategories({
    int page = 1,
    String? search,
    int? perPage,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.categories,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (perPage != null) 'per_page': perPage,
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getFilters({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.tags,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getCompanies({
    int page = 1,
    String? search,
    int? perPage,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.companies,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (perPage != null) 'per_page': perPage,
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getOrders({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.orders,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getClients({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.clients,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  // ─── Generic CRUD ──────────────────────────────

  Future<Map<String, dynamic>> postData(String path, Map<String, dynamic> data) async {
    final res = await _network.post(path, body: data);
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> putData(String path, Map<String, dynamic> data) async {
    final res = await _network.put(path, body: data);
    return (res as Map).cast<String, dynamic>();
  }

  Future<void> deleteData(String path) async {
    await _network.delete(path);
  }
}

