import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/catalog/data/datasource/webstore_reviews_remote_datasource.dart';
import 'package:erp/modules/webstore/catalog/data/repositories/reviews_repository.dart';
import 'package:erp/modules/webstore/catalog/data/models/review_model.dart';

final reviewsRemoteDataSourceProvider =
    Provider<WebStoreReviewsRemoteDataSource>((ref) {
      return WebStoreReviewsRemoteDataSource(ref.watch(networkServiceProvider));
    });

final reviewsRepositoryProvider = Provider<IReviewsRepository>((ref) {
  return ReviewsRepository(ref.watch(reviewsRemoteDataSourceProvider));
});

class ReviewsNotifier extends Notifier<AsyncValue<ReviewModel?>> {
  @override
  AsyncValue<ReviewModel?> build() {
    return const AsyncData(null);
  }

  Future<void> submitReview(
    int productId, {
    required int rating,
    String? review,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(reviewsRepositoryProvider);
    final result = await repository.submitReview(productId, {
      'rating': rating,
      if (review != null && review.isNotEmpty) 'review': review,
    });

    result.when(
      success: (data) => state = AsyncData(data),
      failure: (error) => state = AsyncError(error.message, StackTrace.current),
    );
  }

  Future<void> updateReview(
    int productId, {
    required int rating,
    String? review,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(reviewsRepositoryProvider);
    final result = await repository.updateReview(productId, {
      'rating': rating,
      if (review != null && review.isNotEmpty) 'review': review,
    });

    result.when(
      success: (data) => state = AsyncData(data),
      failure: (error) => state = AsyncError(error.message, StackTrace.current),
    );
  }

  Future<void> deleteReview(int productId) async {
    state = const AsyncLoading();
    final repository = ref.read(reviewsRepositoryProvider);
    final result = await repository.deleteReview(productId);

    result.when(
      success: (_) => state = const AsyncData(null),
      failure: (error) => state = AsyncError(error.message, StackTrace.current),
    );
  }
}

final reviewsNotifierProvider =
    NotifierProvider<ReviewsNotifier, AsyncValue<ReviewModel?>>(() {
      return ReviewsNotifier();
    });
