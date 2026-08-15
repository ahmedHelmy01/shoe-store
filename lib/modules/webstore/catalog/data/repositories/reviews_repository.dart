import 'package:erp/core/mock/mock_data.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/catalog/data/models/review_model.dart';

abstract class IReviewsRepository {
  Future<ApiResult<ReviewModel>> submitReview(int productId, Map<String, dynamic> data);
  Future<ApiResult<ReviewModel>> updateReview(int productId, Map<String, dynamic> data);
  Future<ApiResult<dynamic>> deleteReview(int productId);
}

class ReviewsRepository extends BaseRepository implements IReviewsRepository {
  ReviewsRepository();

  @override
  Future<ApiResult<ReviewModel>> submitReview(int productId, Map<String, dynamic> data) =>
      safeApiCall<ReviewModel>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return MockData.mockReviews.first;
      });

  @override
  Future<ApiResult<ReviewModel>> updateReview(int productId, Map<String, dynamic> data) =>
      safeApiCall<ReviewModel>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return MockData.mockReviews.first;
      });

  @override
  Future<ApiResult<dynamic>> deleteReview(int productId) =>
      safeApiCall<dynamic>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
      });
}
