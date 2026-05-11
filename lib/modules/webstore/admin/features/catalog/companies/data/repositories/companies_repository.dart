import 'package:image_picker/image_picker.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/data/datasource/companies_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/data/models/company_row.dart';

abstract class ICompaniesRepository {
  Future<ApiResult<AdminPagedResponse<CompanyRow>>> getCompanies({
    int page = 1,
    String? search,
    int? perPage,
  });

  Future<ApiResult<CompanyRow>> saveCompany(Map<String, dynamic> data, {int? id, XFile? logoFile, void Function(double)? onProgress});

  Future<ApiResult<void>> deleteCompany(int id);
}

class CompaniesRepository extends AdminBaseRepository implements ICompaniesRepository {
  final CompaniesRemoteDataSource _ds;

  CompaniesRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<CompanyRow>>> getCompanies({
    int page = 1,
    String? search,
    int? perPage,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getCompanies(page: page, search: search, perPage: perPage);
      return parsePaged(json, page, (j) => CompanyRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<CompanyRow>> saveCompany(Map<String, dynamic> data, {int? id, XFile? logoFile, void Function(double)? onProgress}) {
    return safeApiCall(() async {
      final path = id == null
          ? ApiEndpoints.webstore.admin.companies
          : ApiEndpoints.withId(ApiEndpoints.webstore.admin.companies, id);

      final Map<String, dynamic> json;
      if (logoFile != null) {
        final fields = toMultipartFields(data);
        json = id == null
            ? await _ds.postMultipart(path, fields: fields, files: {'logo': logoFile}, onProgress: onProgress)
            : await _ds.putMultipart(path, fields: fields, files: {'logo': logoFile}, onProgress: onProgress);
      } else {
        json = id == null ? await _ds.postData(path, data) : await _ds.putData(path, data);
      }
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
