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
import 'dart:io' show HttpHeaders, SocketException;
import 'package:erp/core/network/network_url.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:logger/logger.dart';

import 'package:erp/core/services/session_manager.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'network_exceptions.dart';
import 'package:erp/core/network/progress_multipart_request.dart';

class NetworkService {
  final http.Client _client;
  final SessionManager _session;
  final Logger _logger = Logger(
    printer: PrettyPrinter(methodCount: 0, printEmojis: true),
  );

  NetworkService(this._client, this._session);

  // ─── Core HTTP Methods ──────────────────────────────

  Future<dynamic> get(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) async {
    return _sendWithMiddleware('GET', path, headers: headers, query: query);
  }

  Future<dynamic> post(
    String path, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    return _sendWithMiddleware('POST', path, body: body, headers: headers);
  }

  Future<dynamic> put(
    String path, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    return _sendWithMiddleware('PUT', path, body: body, headers: headers);
  }

  Future<dynamic> delete(
    String path, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    return _sendWithMiddleware('DELETE', path, body: body, headers: headers);
  }

  Future<dynamic> postMultipart(
    String path, {
    required Map<String, String> fields,
    Map<String, XFile>? files, // fieldName -> XFile
    Map<String, List<XFile>>? multiFiles, // fieldName -> List<XFile>
    Map<String, String>? headers,
    void Function(double)? onProgress,
  }) async {
    return _sendMultipart(
      'POST',
      path,
      fields: fields,
      files: files,
      multiFiles: multiFiles,
      headers: headers,
      onProgress: onProgress,
    );
  }

  Future<dynamic> putMultipart(
    String path, {
    required Map<String, String> fields,
    Map<String, XFile>? files,
    Map<String, List<XFile>>? multiFiles,
    Map<String, String>? headers,
    void Function(double)? onProgress,
  }) async {
    return _sendMultipart(
      'PUT',
      path,
      fields: fields,
      files: files,
      multiFiles: multiFiles,
      headers: headers,
      onProgress: onProgress,
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
    final uri = Uri.parse(url).replace(
      queryParameters: query?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );

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

      final streamedResponse = await _client
          .send(request)
          .timeout(AppConstants.apiTimeout);
      final response = await http.Response.fromStream(streamedResponse);

      // 4. Logging & Processing Response
      _logResponse(response);
      return _processResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw DeadlineExceededException();
    } catch (e) {
      if (e is NetworkException) rethrow;
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('clientexception') || 
          errorStr.contains('connection closed') ||
          errorStr.contains('handshake')) {
        throw NoInternetException();
      }
      throw NetworkException(message: e.toString());
    }
  }

  Future<dynamic> _sendMultipart(
    String method,
    String path, {
    required Map<String, String> fields,
    Map<String, XFile>? files,
    Map<String, List<XFile>>? multiFiles,
    Map<String, String>? headers,
    void Function(double)? onProgress,
  }) async {
    final url = NetworkUrl.fullUrl(path);
    final uri = Uri.parse(url);

    // 1. Prepare Headers (Auth Injection)
    final combinedHeaders = await _getHeaders(headers);
    // Remove content-type, http package will set it for multipart
    combinedHeaders.remove(HttpHeaders.contentTypeHeader);

    // 2. Prepare Request
    final request = ProgressMultipartRequest(
      method,
      uri,
      onProgress: onProgress,
    );
    request.headers.addAll(combinedHeaders);
    request.fields.addAll(fields);

    // 3. Attach Single Files
    if (files != null) {
      for (final entry in files.entries) {
        final xfile = entry.value;
        final bytes = await xfile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(entry.key, bytes, filename: xfile.name),
        );
      }
    }

    // 4. Attach Multi Files (Arrays like images[])
    if (multiFiles != null) {
      for (final entry in multiFiles.entries) {
        for (final xfile in entry.value) {
          final bytes = await xfile.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes(
              entry.key,
              bytes,
              filename: xfile.name,
            ),
          );
        }
      }
    }

    // 5. Logging Request
    _logRequest(
      method,
      uri,
      combinedHeaders,
      'MULTIPART: ${request.fields} | Files: ${files?.keys} | Multi: ${multiFiles?.keys}',
    );

    try {
      final streamedResponse = await _client
          .send(request)
          .timeout(AppConstants.apiTimeout);
      final response = await http.Response.fromStream(streamedResponse);

      _logResponse(response);
      return _processResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw DeadlineExceededException();
    } catch (e) {
      if (e is NetworkException) rethrow;
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('clientexception') || 
          errorStr.contains('connection closed') ||
          errorStr.contains('handshake')) {
        throw NoInternetException();
      }
      throw NetworkException(message: e.toString());
    }
  }

  // ─── Helpers ───────────────────────────────────────

  Future<Map<String, String>> _getHeaders(
    Map<String, String>? extraHeaders,
  ) async {
    final headers = {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json',
      ...?extraHeaders,
    };

    final token = await _session.getAccessToken();
    if (token != null && token.isNotEmpty) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    return headers;
  }

  dynamic _processResponse(http.Response response) {
    final data = _decodeBody(response.body);
    String? serverMessage;
    if (data is Map) {
      serverMessage =
          data['message']?.toString() ??
          data['msg']?.toString() ??
          data['error']?.toString() ??
          data['errorMessage']?.toString();
    }

    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return data;
      case 400:
        throw NetworkException(
          message: serverMessage ?? 'Invalid request',
          statusCode: 400,
          data: data,
        );
      case 401:
        throw UnauthorizedException(message: serverMessage, data: data);
      case 403:
        throw ForbiddenException(message: serverMessage, data: data);
      case 404:
        throw NotFoundException(message: serverMessage, data: data);
      case 422:
        final message = serverMessage ?? 'خطأ في التحقق من البيانات';
        throw ValidationException(message: message, data: data);
      case 500:
        throw InternalServerErrorException(message: serverMessage, data: data);
      default:
        throw NetworkException(
          message: serverMessage ?? 'حدث خطأ في الشبكة',
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

  void _logRequest(
    String method,
    Uri uri,
    Map<String, String> headers,
    dynamic body,
  ) {
    _logger.d('🌐 $method $uri\nHeaders: $headers\nBody: $body');
  }

  void _logResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      _logger.d(
        '✅ ${response.statusCode} ${response.request?.url}\nBody: ${response.body}',
      );
    } else {
      _logger.e(
        '❌ ${response.statusCode} ${response.request?.url}\nError: ${response.body}',
      );
    }
  }
}
