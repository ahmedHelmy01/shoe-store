import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/catalog/data/datasource/webstore_reviews_remote_datasource.dart';
import 'package:erp/modules/webstore/catalog/data/models/review_model.dart';

abstract class IReviewsRepository {
  Future<ApiResult<ReviewModel>> submitReview(int productId, Map<String, dynamic> data);
  Future<ApiResult<ReviewModel>> updateReview(int productId, Map<String, dynamic> data);
  Future<ApiResult<dynamic>> deleteReview(int productId);
}

class ReviewsRepository extends BaseRepository implements IReviewsRepository {
  final WebStoreReviewsRemoteDataSource _remoteDataSource;
  ReviewsRepository(this._remoteDataSource);

  @override
  Future<ApiResult<ReviewModel>> submitReview(int productId, Map<String, dynamic> data) =>
      safeApiCall<ReviewModel>(() async {
        final res = await _remoteDataSource.submitReview(productId, data);
        return ReviewModel.fromJson(res as Map<String, dynamic>);
      });

  @override
  Future<ApiResult<ReviewModel>> updateReview(int productId, Map<String, dynamic> data) =>
      safeApiCall<ReviewModel>(() async {
        final res = await _remoteDataSource.updateReview(productId, data);
        return ReviewModel.fromJson(res as Map<String, dynamic>);
      });

  @override
  Future<ApiResult<dynamic>> deleteReview(int productId) =>
      safeApiCall<dynamic>(() => _remoteDataSource.deleteReview(productId));
}
