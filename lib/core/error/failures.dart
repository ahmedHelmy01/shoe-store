/// ERP System - Failure Classes
///
/// Strongly-typed failure hierarchy for Clean Architecture.
/// Each failure type maps to a specific error scenario.
library;

sealed class Failure {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const Failure({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => '$runtimeType: $message';
}

/// Server returned an error response
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode, super.originalError});
}

/// No internet connection or network error
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'لا يوجد اتصال بالإنترنت'});
}

/// Request timed out
class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'انتهت مهلة الاتصال'});
}

/// Authentication or authorization error
class AuthFailure extends Failure {
  const AuthFailure({super.message = 'يرجى تسجيل الدخول مرة أخرى', super.statusCode});
}

/// Validation error (form data, input)
class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure({
    required super.message,
    this.fieldErrors,
    super.statusCode = 422,
  });
}

/// Cache/Local storage error
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'خطأ في البيانات المحلية'});
}

/// Resource not found
class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'العنصر غير موجود', super.statusCode = 404});
}

/// Unknown/unexpected error
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'حدث خطأ غير متوقع', super.originalError});
}
