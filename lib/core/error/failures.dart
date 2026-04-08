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
  const NetworkFailure({super.message = 'common.no_internet'});
}

/// Request timed out
class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'common.timeout'});
}

/// Authentication or authorization error
class AuthFailure extends Failure {
  const AuthFailure({super.message = 'common.login_again', super.statusCode});
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
  const CacheFailure({super.message = 'common.cache_error'});
}

/// Resource not found
class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'common.item_not_found', super.statusCode = 404});
}

/// Unknown/unexpected error
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'common.unexpected_error', super.originalError});
}
