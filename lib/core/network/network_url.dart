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
    if (path.isEmpty) return '';
    if (path.startsWith('http') || path.startsWith('blob:')) return path;
    
    // ONLY add /storage if it's explicitly a media path starting with uploads/
    // Do NOT match if it's an API path containing the words
    if (path.startsWith('uploads/')) {
      path = 'storage/$path';
    }

    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$baseUrl$cleanPath';
  }

  /// Full URL for uploaded/storage images.
  /// Always prefixes with /storage/ for relative paths (unless already present).
  static String imageUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http') || path.startsWith('blob:')) return path;
    String cleanPath = path.startsWith('/') ? path.substring(1) : path;
    if (!cleanPath.startsWith('storage/')) {
      cleanPath = 'storage/$cleanPath';
    }
    return '$baseUrl/$cleanPath';
  }
}
