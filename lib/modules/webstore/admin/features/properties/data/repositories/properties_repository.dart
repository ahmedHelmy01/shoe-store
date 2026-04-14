import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/properties/data/models/property_row.dart';

abstract class IPropertiesRepository {
  Future<ApiResult<AdminPagedResponse<PropertyRow>>> getProperties({
    int page = 1,
    String? search,
  });

  Future<ApiResult<PropertyRow>> saveProperty(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteProperty(int id);
}

class PropertiesRepository extends AdminBaseRepository implements IPropertiesRepository {
  final WebStoreAdminRemoteDataSource _ds;

  PropertiesRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<PropertyRow>>> getProperties({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getProperties(page: page, search: search);
      return parsePaged(json, page, (j) => PropertyRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<PropertyRow>> saveProperty(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.properties, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.properties, id),
              data,
            );
      return parseSingle(json, (j) => PropertyRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteProperty(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.properties, id),
      );
    });
  }
}
