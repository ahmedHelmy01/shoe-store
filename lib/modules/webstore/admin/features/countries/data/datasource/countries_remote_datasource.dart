import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/shared/data/datasource/admin_remote_datasource.dart';

class CountriesRemoteDataSource extends AdminRemoteDataSource {
  CountriesRemoteDataSource(super.network);

  Future<Map<String, dynamic>> getCountries({
    int page = 1,
    String? search,
    int? perPage,
  }) async {
    final res = await network.get(
      ApiEndpoints.webstore.admin.countries,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (perPage != null) 'per_page': perPage,
      },
    );
    return (res as Map).cast<String, dynamic>();
  }
}
