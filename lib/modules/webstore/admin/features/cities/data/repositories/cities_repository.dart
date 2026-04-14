import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/cities/data/models/city_row.dart';

abstract class ICitiesRepository {
  Future<ApiResult<AdminPagedResponse<CityRow>>> getCities({
    int page = 1,
    String? search,
  });

  Future<ApiResult<CityRow>> saveCity(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteCity(int id);
}

class CitiesRepository extends AdminBaseRepository implements ICitiesRepository {
  final WebStoreAdminRemoteDataSource _ds;

  CitiesRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<CityRow>>> getCities({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getCities(page: page, search: search);
      return parsePaged(json, page, (j) => CityRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<CityRow>> saveCity(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.cities, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.cities, id),
              data,
            );
      return parseSingle(json, (j) => CityRow.fromJson(j));
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
}
