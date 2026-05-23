/// WebStore Reviews Remote DataSource
///
/// Product reviews HTTP calls: submit, update, delete.
library;

import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class WebStoreReviewsRemoteDataSource {
  final NetworkService _networkService;

  WebStoreReviewsRemoteDataSource(this._networkService);

  /// POST /api/store/products/{product}/reviews — Submit a product review
  Future<dynamic> submitReview(int productId, Map<String, dynamic> data) {
    return _networkService.post(
      ApiEndpoints.webstore.catalog.productReviews(productId),
      body: data,
    );
  }

  /// PUT /api/store/products/{product}/reviews — Update product review
  Future<dynamic> updateReview(int productId, Map<String, dynamic> data) {
    return _networkService.put(
      ApiEndpoints.webstore.catalog.productReviews(productId),
      body: data,
    );
  }

  /// DELETE /api/store/products/{product}/reviews — Delete product review
  Future<dynamic> deleteReview(int productId) {
    return _networkService.delete(
      ApiEndpoints.webstore.catalog.productReviews(productId),
    );
  }
}
