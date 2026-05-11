import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/countries/data/datasource/countries_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/countries/data/models/country_row.dart';

abstract class ICountriesRepository {
  Future<ApiResult<AdminPagedResponse<CountryRow>>> getCountries({
    int page = 1,
    String? search,
    int? perPage,
  });

  Future<ApiResult<CountryRow>> saveCountry(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteCountry(int id);
}

class CountriesRepository extends AdminBaseRepository implements ICountriesRepository {
  final CountriesRemoteDataSource _ds;

  CountriesRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<CountryRow>>> getCountries({
    int page = 1,
    String? search,
    int? perPage,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getCountries(page: page, search: search, perPage: perPage);
      return parsePaged(json, page, (j) => CountryRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<CountryRow>> saveCountry(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.countries, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.countries, id),
              data,
            );
      return parseSingle(json, (j) => CountryRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteCountry(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.countries, id),
      );
    });
  }
}
