/// ERP System - Environment Configuration
///
/// Centralized environment settings.
/// Change baseUrl here to switch between dev/staging/production.
library;

class EnvConfig {
  EnvConfig._();

  /// API Base URL
  static const String baseUrl = 'https://moon-erp.elbaset.com';

  /// API Version prefix (if needed)
  static const String apiPrefix = '/api';

  /// Connection timeout in seconds
  static const int connectTimeout = 30;

  /// Receive timeout in seconds
  static const int receiveTimeout = 30;

  /// Enable/disable request logging
  static const bool enableLogging = true;

  /// Max retry attempts for failed requests
  static const int maxRetryAttempts = 3;

  /// Retry delay in milliseconds
  static const int retryDelay = 1000;

  /// Cache duration for API responses (in minutes)
  static const int cacheDuration = 5;

  /// Pagination default page size
  static const int defaultPageSize = 15;

  /// Image upload max size in MB
  static const int maxImageSizeMB = 5;

  /// Supported image formats
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
}
