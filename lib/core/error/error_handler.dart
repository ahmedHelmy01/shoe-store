/// ERP System - Error Handler
///
/// Maps API exceptions to user-friendly Failure objects.
/// Used by repositories to convert raw errors into domain failures.
library;

import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'failures.dart';

class ErrorHandler {
  ErrorHandler._();

  /// Convert an ApiException to a typed Failure
  static Failure mapException(ApiException exception) {
    return switch (exception.type) {
      ApiErrorType.network => const NetworkFailure(),
      ApiErrorType.timeout => const TimeoutFailure(),
      ApiErrorType.unauthorized => AuthFailure(
          message: exception.message,
          statusCode: exception.statusCode,
        ),
      ApiErrorType.notFound => NotFoundFailure(
          message: exception.message,
          statusCode: exception.statusCode,
        ),
      ApiErrorType.validation => ValidationFailure(
          message: exception.message,
          statusCode: exception.statusCode,
        ),
      ApiErrorType.server => ServerFailure(
          message: exception.message,
          statusCode: exception.statusCode,
        ),
      ApiErrorType.cancelled => ServerFailure(
          message: LocaleKeys.common.request_cancelled,
          statusCode: exception.statusCode,
        ),
      ApiErrorType.client => ServerFailure(
          message: exception.message,
          statusCode: exception.statusCode,
        ),
      ApiErrorType.unknown => UnexpectedFailure(
          message: exception.message,
          originalError: exception.originalError,
        ),
    };
  }

  /// Get user-friendly error message from a Failure
  static String getUserMessage(Failure failure) {
    return switch (failure) {
      NetworkFailure() => LocaleKeys.common.check_internet,
      TimeoutFailure() => LocaleKeys.common.server_not_responding,
      AuthFailure() => LocaleKeys.common.session_expired_login_again,
      ValidationFailure(message: final msg) => msg,
      ServerFailure(message: final msg) => msg,
      NotFoundFailure() => LocaleKeys.common.not_found_requested,
      CacheFailure() => LocaleKeys.common.cache_load_error,
      UnexpectedFailure() => LocaleKeys.common.unexpected_error_retry,
    };
  }
}
