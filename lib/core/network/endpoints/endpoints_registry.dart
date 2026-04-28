/// API Endpoints Registry
///
/// Centralized access point for all modular endpoints.
/// Supports 14+ modules with clean hierarchical access.
library;

import 'auth_endpoints.dart';
import 'webstore_endpoints.dart';

class ApiEndpoints {
  ApiEndpoints._();

  /// 🔐 Auth Module
  static const auth = AuthEndpoints();

  /// 🛒 WebStore Module
  static const webstore = WebStoreEndpoints();

  // ─── Helpers ───────────────────────────────────────

  /// Replace path parameters like {id} with actual values
  static String withId(String path, dynamic id) {
    if (path.contains('{id}')) {
      return path.replaceAll('{id}', id.toString());
    } else {
      final cleanPath = path.endsWith('/') ? path.substring(0, path.length - 1) : path;
      return '$cleanPath/$id';
    }
  }

  /// Replace path parameter {slug} with actual value
  static String withSlug(String path, String slug) {
    return path.replaceAll('{slug}', slug);
  }

  /// Replace multiple path parameters
  static String withParams(String path, Map<String, dynamic> params) {
    var result = path;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value.toString());
    });
    return result;
  }
}
