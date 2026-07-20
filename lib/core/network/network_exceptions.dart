/// Network Exceptions
///
/// Strongly-typed network exceptions mapping to HTTP status codes.
library;

import 'package:erp/core/localization/locale_keys.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  NetworkException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'NetworkException: $message (Code: $statusCode)';
}

/// 📶 No Internet Connection
class NoInternetException extends NetworkException {
  NoInternetException() : super(message: LocaleKeys.common.no_internet);
}

/// ⏱️ Request Timeout
class DeadlineExceededException extends NetworkException {
  DeadlineExceededException() : super(message: LocaleKeys.common.timeout_server);
}

/// 🔐 Unauthorized (401)
class UnauthorizedException extends NetworkException {
  UnauthorizedException({String? message, super.data})
      : super(
          message: message ?? LocaleKeys.common.unauthorized,
          statusCode: 401,
        );
}

/// ✋ Forbidden (403)
class ForbiddenException extends NetworkException {
  ForbiddenException({String? message, super.data})
      : super(
          message: message ?? LocaleKeys.common.forbidden,
          statusCode: 403,
        );
}

/// 🔍 Not Found (404)
class NotFoundException extends NetworkException {
  NotFoundException({String? message, super.data})
      : super(
          message: message ?? LocaleKeys.common.not_found_requested,
          statusCode: 404,
        );
}

/// 📄 Conflict (409)
class ConflictException extends NetworkException {
  ConflictException({String? message, super.data})
      : super(
          message: message ?? LocaleKeys.common.conflict,
          statusCode: 409,
        );
}

/// 🏗️ Internal Server Error (500)
class InternalServerErrorException extends NetworkException {
  InternalServerErrorException({String? message, super.data})
      : super(
          message: message ?? LocaleKeys.common.server_error_try_later,
          statusCode: 500,
        );
}

/// 📋 Validation Error (422)
class ValidationException extends NetworkException {
  ValidationException({required super.message, super.statusCode = 422, super.data});
}
