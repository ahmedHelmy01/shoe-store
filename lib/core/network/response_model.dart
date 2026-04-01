/// Network Response Model
///
/// Standardized response wrapper for all API calls.
library;

class NetworkResponse {
  final int statusCode;
  final dynamic data;
  final Map<String, String> headers;

  const NetworkResponse({
    required this.statusCode,
    required this.data,
    required this.headers,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
  bool get isRedirect => statusCode >= 300 && statusCode < 400;
  bool get isError => statusCode >= 400;

  @override
  String toString() => 'Response($statusCode): $data';
}
