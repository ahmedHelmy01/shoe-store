import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/data/models/company_row.dart';

final companiesVmProvider = NotifierProvider.autoDispose<CompaniesVm, AdminCrudState<CompanyRow>>(CompaniesVm.new);

class CompaniesVm extends AdminCrudVm<CompanyRow> {
  @override
  Future<ApiResult<AdminPagedResponse<CompanyRow>>> getItems({required int page, String? search, int? perPage}) {
    return ref.read(companiesRepositoryProvider).getCompanies(page: page, search: search, perPage: perPage);
  }

  @override
  Future<ApiResult<CompanyRow>> saveItem(Map<String, dynamic> data, {dynamic id}) {
    return ref.read(companiesRepositoryProvider).saveCompany(data, id: id as int?);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(companiesRepositoryProvider).deleteCompany(id as int);
  }
}
