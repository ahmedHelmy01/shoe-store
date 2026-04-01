/// ERP System - Error Handler
///
/// Maps API exceptions to user-friendly Failure objects.
/// Used by repositories to convert raw errors into domain failures.
library;

import 'package:erp/core/network/api_result.dart';
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
          message: 'تم إلغاء الطلب',
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
      NetworkFailure() => 'تأكد من اتصالك بالإنترنت وحاول مرة أخرى',
      TimeoutFailure() => 'السيرفر لا يستجيب، حاول مرة أخرى',
      AuthFailure() => 'جلستك انتهت، يرجى تسجيل الدخول مرة أخرى',
      ValidationFailure(message: final msg) => msg,
      ServerFailure(message: final msg) => msg,
      NotFoundFailure() => 'العنصر المطلوب غير موجود',
      CacheFailure() => 'خطأ في تحميل البيانات المحلية',
      UnexpectedFailure() => 'حدث خطأ غير متوقع، حاول مرة أخرى',
    };
  }
}
