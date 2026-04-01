/// Network Exceptions
///
/// Strongly-typed network exceptions mapping to HTTP status codes.
library;

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
  const NoInternetException() : super(message: 'لا يوجد اتصال بالإنترنت');
}

/// ⏱️ Request Timeout
class DeadlineExceededException extends NetworkException {
  const DeadlineExceededException() : super(message: 'انتهت مهلة الاتصال بالخادم');
}

/// 🔐 Unauthorized (401)
class UnauthorizedException extends NetworkException {
  const UnauthorizedException({super.message = 'غير مصرح لك، يرجى تسجيل الدخول', super.statusCode = 401, super.data});
}

/// ✋ Forbidden (403)
class ForbiddenException extends NetworkException {
  const ForbiddenException({super.message = 'ليس لديك صلاحية للوصول', super.statusCode = 403, super.data});
}

/// 🔍 Not Found (404)
class NotFoundException extends NetworkException {
  const NotFoundException({super.message = 'العنصر المطلوب غير موجود', super.statusCode = 404, super.data});
}

/// 📄 Conflict (409)
class ConflictException extends NetworkException {
  const ConflictException({super.message = 'حدث خطأ في البيانات المرسلة', super.statusCode = 409, super.data});
}

/// 🏗️ Internal Server Error (500)
class InternalServerErrorException extends NetworkException {
  const InternalServerErrorException({super.message = 'حدث خطأ في الخادم، حاول لاحقاً', super.statusCode = 500, super.data});
}

/// 📋 Validation Error (422)
class ValidationException extends NetworkException {
  const ValidationException({required super.message, super.statusCode = 422, super.data});
}
