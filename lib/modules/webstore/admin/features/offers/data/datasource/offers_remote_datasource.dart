import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/shared/data/datasource/admin_remote_datasource.dart';

class OffersRemoteDataSource extends AdminRemoteDataSource {
  OffersRemoteDataSource(super.network);

  Future<Map<String, dynamic>> getOffers({
    int page = 1,
    String? search,
  }) async {
    final res = await network.get(
      ApiEndpoints.webstore.admin.offers,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getOffer(int id) async {
    final res = await network.get(
      ApiEndpoints.withId(ApiEndpoints.webstore.admin.offers, id),
    );
    return (res as Map).cast<String, dynamic>();
  }
}
