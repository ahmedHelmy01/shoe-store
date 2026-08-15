import 'package:erp/core/mock/mock_data.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';

abstract class IWishlistRepository {
  Future<ApiResult<Map<String, dynamic>>> getWishlist();
  Future<ApiResult<Map<String, dynamic>>> addToWishlist(int productId);
  Future<ApiResult<Map<String, dynamic>>> removeFromWishlist(int productId);
}

class WishlistRepository extends BaseRepository implements IWishlistRepository {
  WishlistRepository();

  @override
  Future<ApiResult<Map<String, dynamic>>> getWishlist() =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {
          'data': MockData.mockProducts.take(3).map((e) => e.toJson()).toList(),
        };
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> addToWishlist(int productId) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {'message': 'تمت الإضافة بنجاح'};
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> removeFromWishlist(int productId) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {'message': 'تمت الإزالة بنجاح'};
      });
}
