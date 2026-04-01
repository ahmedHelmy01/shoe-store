/// ERP System - Network Service
///
/// Advanced HTTP wrapper built on the 'http' package.
/// Implements enterprise-grade middleware emulation for:
/// - Authentication token injection
/// - Request/Response logging
/// - Network connectivity check
/// - Consistent Error/Exception mapping
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'package:erp/core/storage/secure_storage.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'network_exceptions.dart';
import 'network_url.dart';

class NetworkService {
  final http.Client _client;
  final SecureStorage _secureStorage;
  final Logger _logger = Logger(
    printer: PrettyPrinter(methodCount: 0, printEmojis: true),
  );

  NetworkService(this._client, this._secureStorage);

  // ─── Core HTTP Methods ──────────────────────────────

  Future<dynamic> get(String path, {Map<String, String>? headers, Map<String, dynamic>? query}) async {
    return _sendWithMiddleware(
      'GET',
      path,
      headers: headers,
      query: query,
    );
  }

  Future<dynamic> post(String path, {dynamic body, Map<String, String>? headers}) async {
    return _sendWithMiddleware(
      'POST',
      path,
      body: body,
      headers: headers,
    );
  }

  Future<dynamic> put(String path, {dynamic body, Map<String, String>? headers}) async {
    return _sendWithMiddleware(
      'PUT',
      path,
      body: body,
      headers: headers,
    );
  }

  Future<dynamic> delete(String path, {dynamic body, Map<String, String>? headers}) async {
    return _sendWithMiddleware(
      'DELETE',
      path,
      body: body,
      headers: headers,
    );
  }

  // ─── Middleware Emulation ───────────────────────────

  Future<dynamic> _sendWithMiddleware(
    String method,
    String path, {
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) async {
    final url = NetworkUrl.fullUrl(path);
    final uri = Uri.parse(url).replace(queryParameters: query?.map((key, value) => MapEntry(key, value.toString())));

    // 1. Prepare Headers (Auth Injection)
    final combinedHeaders = await _getHeaders(headers);

    // 2. Logging Request
    _logRequest(method, uri, combinedHeaders, body);

    try {
      // 3. Send Request
      final request = http.Request(method, uri);
      request.headers.addAll(combinedHeaders);
      if (body != null) {
        request.body = jsonEncode(body);
        request.headers[HttpHeaders.contentTypeHeader] = 'application/json';
      }

      final streamedResponse = await _client.send(request).timeout(AppConstants.apiTimeout);
      final response = await http.Response.fromStream(streamedResponse);

      // 4. Logging & Processing Response
      _logResponse(response);
      return _processResponse(response);
    } on SocketException {
      throw const NoInternetException();
    } on TimeoutException {
      throw const DeadlineExceededException();
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException(message: e.toString());
    }
  }

  // ─── Helpers ───────────────────────────────────────

  Future<Map<String, String>> _getHeaders(Map<String, String>? extraHeaders) async {
    final headers = {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json',
      ...?extraHeaders,
    };

    final token = await _secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    return headers;
  }

  dynamic _processResponse(http.Response response) {
    final data = _decodeBody(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return data;
      case 400:
        throw NetworkException(message: 'Invalid request', statusCode: 400, data: data);
      case 401:
        throw UnauthorizedException(data: data);
      case 403:
        throw ForbiddenException(data: data);
      case 404:
        throw NotFoundException(data: data);
      case 422:
        final message = data['message'] ?? 'خطأ في التحقق من البيانات';
        throw ValidationException(message: message, data: data);
      case 500:
        throw InternalServerErrorException(data: data);
      default:
        throw NetworkException(
          message: 'حدث خطأ في الشبكة',
          statusCode: response.statusCode,
          data: data,
        );
    }
  }

  dynamic _decodeBody(String body) {
    if (body.isEmpty) return null;
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  // ─── Logging ──────────────────────────────────────

  void _logRequest(String method, Uri uri, Map<String, String> headers, dynamic body) {
    _logger.d('🌐 $method $uri\nHeaders: $headers\nBody: $body');
  }

  void _logResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      _logger.d('✅ ${response.statusCode} ${response.request?.url}\nBody: ${response.body}');
    } else {
      _logger.e('❌ ${response.statusCode} ${response.request?.url}\nError: ${response.body}');
    }
  }
}
