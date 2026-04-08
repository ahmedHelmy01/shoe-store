import 'dart:async';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/network_exceptions.dart';
import 'package:erp/core/localization/locale_keys.dart';

/// Base Repository
/// Provides a safety wrapper for API calls to convert exceptions to ApiResult.
abstract class BaseRepository {
  /// Wraps an API call and maps exceptions to the standard ApiResult type.
  Future<ApiResult<T>> safeApiCall<T>(Future<dynamic> Function() call) async {
    try {
      final response = await call();
      return ApiSuccess<T>(response as T);
    } catch (e) {
      if (e is NoInternetException) {
        return const ApiFailure(
          ApiException(
            message: LocaleKeys.common.no_internet,
            type: ApiErrorType.network,
          ),
        );
      }
      return ApiFailure<T>(_mapExceptionToApiException(e));
    }
  }

  ApiException _mapExceptionToApiException(dynamic e) {
    if (e is TimeoutException || e is DeadlineExceededException) {
      return const ApiException(
        message: LocaleKeys.common.timeout_server,
        type: ApiErrorType.timeout,
      );
    }

    if (e is UnauthorizedException) {
      return ApiException(
        message: e.message,
        statusCode: 401,
        type: ApiErrorType.unauthorized,
        originalError: e.data,
      );
    }

    if (e is ForbiddenException) {
      return ApiException(
        message: e.message,
        statusCode: 403,
        type: ApiErrorType.unauthorized,
        originalError: e.data,
      );
    }

    if (e is ValidationException) {
      return ApiException(
        message: e.message,
        statusCode: 422,
        type: ApiErrorType.validation,
        originalError: e.data,
      );
    }

    if (e is NetworkException) {
      return ApiException(
        message: e.message,
        statusCode: e.statusCode,
        originalError: e.data,
        type: _mapStatusCodeToErrorType(e.statusCode),
      );
    }

    return ApiException(message: e.toString(), type: ApiErrorType.unknown);
  }

  ApiErrorType _mapStatusCodeToErrorType(int? statusCode) {
    if (statusCode == null) return ApiErrorType.unknown;
    if (statusCode == 401 || statusCode == 403)
      return ApiErrorType.unauthorized;
    if (statusCode == 404) return ApiErrorType.notFound;
    if (statusCode >= 400 && statusCode < 500) return ApiErrorType.client;
    if (statusCode >= 500) return ApiErrorType.server;
    return ApiErrorType.unknown;
  }
}
