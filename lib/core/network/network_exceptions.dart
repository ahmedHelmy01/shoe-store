/// Network Exceptions
///
/// Strongly-typed network exceptions mapping to HTTP status codes.
library;

import 'package:erp/core/localization/locale_keys.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const NetworkException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'NetworkException: $message (Code: $statusCode)';
}

/// 📶 No Internet Connection
class NoInternetException extends NetworkException {
  const NoInternetException() : super(message: LocaleKeys.common.no_internet);
}

/// ⏱️ Request Timeout
class DeadlineExceededException extends NetworkException {
  const DeadlineExceededException() : super(message: LocaleKeys.common.timeout_server);
}

/// 🔐 Unauthorized (401)
class UnauthorizedException extends NetworkException {
  const UnauthorizedException({
    super.message = LocaleKeys.common.unauthorized,
    super.statusCode = 401,
    super.data,
  });
}

/// ✋ Forbidden (403)
class ForbiddenException extends NetworkException {
  const ForbiddenException({
    super.message = LocaleKeys.common.forbidden,
    super.statusCode = 403,
    super.data,
  });
}

/// 🔍 Not Found (404)
class NotFoundException extends NetworkException {
  const NotFoundException({
    super.message = LocaleKeys.common.not_found_requested,
    super.statusCode = 404,
    super.data,
  });
}

/// 📄 Conflict (409)
class ConflictException extends NetworkException {
  const ConflictException({
    super.message = LocaleKeys.common.conflict,
    super.statusCode = 409,
    super.data,
  });
}

/// 🏗️ Internal Server Error (500)
class InternalServerErrorException extends NetworkException {
  const InternalServerErrorException({
    super.message = LocaleKeys.common.server_error_try_later,
    super.statusCode = 500,
    super.data,
  });
}

/// 📋 Validation Error (422)
class ValidationException extends NetworkException {
  const ValidationException({required super.message, super.statusCode = 422, super.data});
}
