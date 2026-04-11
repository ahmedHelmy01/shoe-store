import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class WebStoreAdminRemoteDataSource {
  final NetworkService _network;

  WebStoreAdminRemoteDataSource(this._network);

  Future<Map<String, dynamic>> getProducts({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.products,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getBranches({
    int page = 1,
    String? search,
  }) async {
    final res = await _network.get(
      ApiEndpoints.webstore.admin.branches,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
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
}

