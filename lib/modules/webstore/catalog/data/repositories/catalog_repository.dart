import 'package:erp/core/mock/mock_data.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';

abstract class ICatalogRepository {
  Future<ApiResult<Map<String, dynamic>>> getProducts({
    Map<String, dynamic>? queryParams,
  });
  Future<ApiResult<Map<String, dynamic>>> getProductDetail(int id);
  Future<ApiResult<Map<String, dynamic>>> getCategories({
    Map<String, dynamic>? queryParams,
  });
  Future<ApiResult<Map<String, dynamic>>> getCategoryDetail(int id);
  Future<ApiResult<Map<String, dynamic>>> searchProducts(String query);
  Future<ApiResult<Map<String, dynamic>>> getManufacturers();
  Future<ApiResult<Map<String, dynamic>>> getTags();
}

class CatalogRepository extends BaseRepository implements ICatalogRepository {
  CatalogRepository();

  @override
  Future<ApiResult<Map<String, dynamic>>> getProducts({
    Map<String, dynamic>? queryParams,
  }) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {
          'data': MockData.mockProducts.map((e) => e.toJson()).toList(),
          'total': MockData.mockProducts.length,
        };
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> getProductDetail(int id) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        final product = MockData.mockProducts.firstWhere(
          (p) => p.id == id,
          orElse: () => MockData.mockProducts.first,
        );
        return {'data': product.toJson()};
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> getCategories({
    Map<String, dynamic>? queryParams,
  }) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {
          'data': MockData.mockCategories.map((e) => e.toJson()).toList(),
        };
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> getCategoryDetail(int id) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        final category = MockData.mockCategories.firstWhere(
          (c) => c.id == id,
          orElse: () => MockData.mockCategories.first,
        );
        return {'data': category.toJson()};
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> searchProducts(String query) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        final results = MockData.mockProducts
            .where((p) => p.name.contains(query))
            .toList();
        return {
          'data': results.map((e) => e.toJson()).toList(),
          'total': results.length,
        };
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> getManufacturers() =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {
          'data': MockData.mockManufacturers.map((e) => e.toJson()).toList(),
        };
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> getTags() =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {
          'data': MockData.mockTags.map((e) => e.toJson()).toList(),
        };
      });
}
