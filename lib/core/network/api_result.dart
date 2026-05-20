/// ERP System - API Result Wrapper
///
/// Provides a type-safe way to handle API responses
/// using sealed classes (Union types).
library;

sealed class ApiResult<T> {
  const ApiResult();

  /// Execute different callbacks based on the result type
  R when<R>({
    required R Function(T data) success,
    required R Function(ApiException exception) failure,
  }) {
    return switch (this) {
      ApiSuccess<T>(data: final data) => success(data),
      ApiFailure<T>(exception: final exception) => failure(exception),
    };
  }

  /// Map the success value to a new type
  ApiResult<R> map<R>(R Function(T data) mapper) {
    return switch (this) {
      ApiSuccess<T>(data: final data) => ApiSuccess(mapper(data)),
      ApiFailure<T>(exception: final e) => ApiFailure(e),
    };
  }

  /// Get the data or null
  T? get dataOrNull => switch (this) {
    ApiSuccess<T>(data: final data) => data,
    ApiFailure<T>() => null,
  };

  /// Check if success
  bool get isSuccess => this is ApiSuccess<T>;

  /// Check if failure
  bool get isFailure => this is ApiFailure<T>;
}

/// Successful API result containing data
class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

/// Failed API result containing an exception
class ApiFailure<T> extends ApiResult<T> {
  final ApiException exception;
  const ApiFailure(this.exception);
}

/// API Exception with structured error information
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;
  final ApiErrorType type;

  const ApiException({
    required this.message,
    this.statusCode,
    this.originalError,
    this.type = ApiErrorType.unknown,
  });

  @override
  String toString() => 'ApiException($type): [$statusCode] $message';

  /// User-facing message including Laravel-style validation `errors` map.
  String get displayMessage {
    final fieldErrors = parseValidationErrors(originalError);
    if (fieldErrors.isNotEmpty) return fieldErrors.join('\n');
    return message;
  }

  /// Extracts messages from `{ "message": "...", "errors": { "field": ["..."] } }`.
  static List<String> parseValidationErrors(dynamic data) {
    if (data is! Map) return [];
    final messages = <String>[];

    final errors = data['errors'];
    if (errors is Map) {
      for (final value in errors.values) {
        if (value is List) {
          for (final item in value) {
            final text = item?.toString().trim();
            if (text != null && text.isNotEmpty) messages.add(text);
          }
        } else {
          final text = value?.toString().trim();
          if (text != null && text.isNotEmpty) messages.add(text);
        }
      }
    }

    if (messages.isEmpty) {
      final msg = data['message']?.toString().trim();
      if (msg != null && msg.isNotEmpty) messages.add(msg);
    }

    return messages;
  }
}

/// Categorized error types for consistent error handling
enum ApiErrorType {
  /// Network connectivity issues
  network,

  /// Request timeout
  timeout,

  /// Server returned an error (5xx)
  server,

  /// Client error (4xx)
  client,

  /// Authentication/Authorization failure (401/403)
  unauthorized,

  /// Resource not found (404)
  notFound,

  /// Validation error (422)
  validation,

  /// Request cancelled
  cancelled,

  /// Unknown/unhandled error
  unknown,
}
