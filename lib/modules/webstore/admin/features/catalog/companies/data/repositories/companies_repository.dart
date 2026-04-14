import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/data/models/company_row.dart';

abstract class ICompaniesRepository {
  Future<ApiResult<AdminPagedResponse<CompanyRow>>> getCompanies({
    int page = 1,
    String? search,
  });

  Future<ApiResult<CompanyRow>> saveCompany(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteCompany(int id);
}

class CompaniesRepository extends AdminBaseRepository implements ICompaniesRepository {
  final WebStoreAdminRemoteDataSource _ds;

  CompaniesRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<CompanyRow>>> getCompanies({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getCompanies(page: page, search: search);
      return parsePaged(json, page, (j) => CompanyRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<CompanyRow>> saveCompany(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.companies, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.companies, id),
              data,
            );
      return parseSingle(json, (j) => CompanyRow.fromJson(j));
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
}
