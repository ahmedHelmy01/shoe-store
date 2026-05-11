import 'package:image_picker/image_picker.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/datasource/products_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/models/product_row.dart';

abstract class IProductsRepository {
  Future<ApiResult<AdminPagedResponse<ProductRow>>> getProducts({
    int page = 1,
    String? search,
    int? perPage,
  });

  Future<ApiResult<ProductRow>> saveProduct(Map<String, dynamic> data, {int? id, XFile? imageFile, List<XFile>? galleryFiles, void Function(double)? onProgress});

  Future<ApiResult<void>> deleteProduct(int id);

  Future<ApiResult<ProductRow>> getProduct(int id);
}

class ProductsRepository extends AdminBaseRepository implements IProductsRepository {
  final ProductsRemoteDataSource _ds;

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
  Future<ApiResult<ProductRow>> saveProduct(Map<String, dynamic> data, {int? id, XFile? imageFile, List<XFile>? galleryFiles, void Function(double)? onProgress}) {
    return safeApiCall(() async {
      final path = id == null
          ? ApiEndpoints.webstore.admin.products
          : ApiEndpoints.withId(ApiEndpoints.webstore.admin.products, id);

      final Map<String, dynamic> json;
      if (imageFile != null || galleryFiles != null) {
        // Convert all fields to strings for multipart
        final fields = toMultipartFields(data);

        final Map<String, XFile> files = {};
        if (imageFile != null) files['image'] = imageFile;

        final multiFiles = <String, List<XFile>>{};
        if (galleryFiles != null) {
          multiFiles['images[]'] = galleryFiles;
        }

        json = id == null
            ? await _ds.postMultipart(path, fields: fields, files: files, multiFiles: multiFiles, onProgress: onProgress)
            : await _ds.putMultipart(path, fields: fields, files: files, multiFiles: multiFiles, onProgress: onProgress);
      } else {
        json = id == null ? await _ds.postData(path, data) : await _ds.putData(path, data);
      }
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

  @override
  Future<ApiResult<ProductRow>> getProduct(int id) {
    return safeApiCall(() async {
      final json = await _ds.getProduct(id);
      return parseSingle(json, (j) => ProductRow.fromJson(j));
    });
  }
}

