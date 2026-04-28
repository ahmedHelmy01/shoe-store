import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/models/product_row.dart';

abstract class IProductsRepository {
  Future<ApiResult<AdminPagedResponse<ProductRow>>> getProducts({
    int page = 1,
    String? search,
    int? perPage,
  });

  Future<ApiResult<ProductRow>> saveProduct(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteProduct(int id);
}

class ProductsRepository extends AdminBaseRepository implements IProductsRepository {
  final WebStoreAdminRemoteDataSource _ds;

  ProductsRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<ProductRow>>> getProducts({
    int page = 1,
    String? search,
    int? perPage,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getProducts(page: page, search: search, perPage: perPage);
      return parsePaged(json, page, (j) => ProductRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<ProductRow>> saveProduct(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.products, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.products, id),
              data,
            );
      return parseSingle(json, (j) => ProductRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteProduct(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.products, id),
      );
    });
  }
}
