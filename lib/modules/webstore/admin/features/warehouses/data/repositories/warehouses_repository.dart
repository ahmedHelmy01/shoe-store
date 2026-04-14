import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/warehouses/data/models/warehouse_row.dart';

abstract class IWarehousesRepository {
  Future<ApiResult<AdminPagedResponse<WarehouseRow>>> getWarehouses({
    int page = 1,
    String? search,
  });

  Future<ApiResult<WarehouseRow>> saveWarehouse(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteWarehouse(int id);
}

class WarehousesRepository extends AdminBaseRepository implements IWarehousesRepository {
  final WebStoreAdminRemoteDataSource _ds;

  WarehousesRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<WarehouseRow>>> getWarehouses({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getWarehouses(page: page, search: search);
      return parsePaged(json, page, (j) => WarehouseRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<WarehouseRow>> saveWarehouse(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.warehouses, data)
          : await _ds.putData(
              '${ApiEndpoints.webstore.admin.warehouses}/$id',
              data,
            );
      return parseSingle(json, (j) => WarehouseRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteWarehouse(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        '${ApiEndpoints.webstore.admin.warehouses}/$id',
      );
    });
  }
}
