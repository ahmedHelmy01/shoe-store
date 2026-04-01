/// Network URL Manager
///
/// Manages base URLs and path concatenations based on app flavor.
library;

import 'package:erp/core/config/env_config.dart';

class NetworkUrl {
  NetworkUrl._();

  /// The primary API base URL
  static String get baseUrl => EnvConfig.baseUrl;

  /// Full URL combined with base
  static String fullUrl(String path) {
    if (path.startsWith('http')) return path;
    
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$baseUrl$cleanPath';
  }
}
