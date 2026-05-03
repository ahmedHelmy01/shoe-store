import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/customers/customer_groups/data/datasource/customer_groups_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/customers/customer_groups/data/models/customer_group_row.dart';

abstract class ICustomerGroupsRepository {
  Future<ApiResult<AdminPagedResponse<CustomerGroupRow>>> getCustomerGroups({
    int page = 1,
    String? search,
  });

  Future<ApiResult<CustomerGroupRow>> saveCustomerGroup(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteCustomerGroup(int id);
}

class CustomerGroupsRepository extends AdminBaseRepository implements ICustomerGroupsRepository {
  final CustomerGroupsRemoteDataSource _ds;

  CustomerGroupsRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<CustomerGroupRow>>> getCustomerGroups({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getCustomerGroups(page: page, search: search);
      return parsePaged(json, page, (j) => CustomerGroupRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<CustomerGroupRow>> saveCustomerGroup(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.customerGroups, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.customerGroups, id),
              data,
            );
      return parseSingle(json, (j) => CustomerGroupRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteCustomerGroup(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.customerGroups, id),
      );
    });
  }
}
