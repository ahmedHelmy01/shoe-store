import 'dart:async';
import 'dart:convert';
import 'dart:io' show HttpHeaders, SocketException;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart' show XFile;

import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/network/endpoints/webstore_endpoints.dart';
import 'package:erp/core/network/network_exceptions.dart';
import 'package:erp/core/network/network_url.dart';
import 'package:erp/core/network/progress_multipart_request.dart';
import 'package:erp/core/services/session_manager.dart';
import 'package:http/http.dart' as http;

class UploadService {
  final http.Client _client;
  final SessionManager _session;
  final WebStoreEndpoints _endpoints;

  UploadService(
    this._client,
    this._session, {
    WebStoreEndpoints endpoints = const _WebStoreEndpoints(),
  }) : _endpoints = endpoints;

  /// Uploads a single file and returns the uploaded image path from API response.
  Future<String> uploadSingle({
    required XFile file,
    required String uploadFolder,
    String fileFieldName = 'file',
    String uploadFolderFieldName = 'upload_folder',
    void Function(double)? onProgress,
  }) async {
    final bytes = await file.readAsBytes();

    final responseData = await _sendMultipart(
      endpoint: _endpoints.upload.single,
      fields: {uploadFolderFieldName: uploadFolder},
      files: [
        http.MultipartFile.fromBytes(
          fileFieldName,
          bytes,
          filename: file.name,
        ),
      ],
      onProgress: onProgress,
    );

    return _extractPathOrThrow(responseData);
  }

  /// Uploads multiple files and returns the extracted image paths.
  Future<List<String>> uploadMultiple({
    required List<XFile> xFiles,
    required String uploadFolder,
    String filesFieldName = 'files[]',
    String uploadFolderFieldName = 'upload_folder',
    void Function(double)? onProgress,
  }) async {
    if (xFiles.isEmpty) {
      throw NetworkException(message: 'Please provide at least one file to upload');
    }

    final files = <http.MultipartFile>[];
    for (final file in xFiles) {
      final bytes = await file.readAsBytes();
      files.add(
        http.MultipartFile.fromBytes(
          filesFieldName,
          bytes,
          filename: file.name,
        ),
      );
    }

    final responseData = await _sendMultipart(
      endpoint: _endpoints.upload.multiple,
      fields: {uploadFolderFieldName: uploadFolder},
      files: files,
      onProgress: onProgress,
    );

    final extracted = _extractMultiplePaths(responseData);
    if (extracted.isEmpty) {
      throw NetworkException(message: 'Upload succeeded but no file paths returned');
    }
    return extracted;
  }

  /// Deletes uploaded file by its path on server.
  Future<void> deleteUploadedFile(String filePath) async {
    final url = Uri.parse(NetworkUrl.fullUrl(_endpoints.upload.delete));
    final headers = await _authHeaders(contentTypeJson: true);

    try {
      final response = await _client
          .post(
            url,
            headers: headers,
            body: jsonEncode({'file_path': filePath}),
          )
          .timeout(AppConstants.apiTimeout);

      final bodyData = _decodeBody(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw NetworkException(
          message: _messageFrom(bodyData) ?? 'Failed to delete uploaded file',
          statusCode: response.statusCode,
          data: bodyData,
        );
      }
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw DeadlineExceededException();
    }
  }

  Future<dynamic> _sendMultipart({
    required String endpoint,
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
    void Function(double)? onProgress,
  }) async {
    final urlStr = NetworkUrl.fullUrl(endpoint);
    final uri = Uri.parse(urlStr);
    final headers = await _authHeaders(contentTypeJson: false);

    if (kDebugMode) {
      print('🚀 [UploadService] Starting Upload...');
      print('   📍 URL: $urlStr');
      print('   📂 Request Headers: $headers');
    }

    final request = ProgressMultipartRequest('POST', uri, onProgress: onProgress)
      ..headers.addAll(headers)
      ..fields.addAll(fields)
      ..files.addAll(files);

    try {
      final streamed = await _client.send(request).timeout(AppConstants.apiTimeout);
      final response = await http.Response.fromStream(streamed);
      final bodyData = _decodeBody(response.body);

      if (kDebugMode) {
        print('✅ [UploadService] Response Received!');
        print('   🚥 Status: ${response.statusCode}');
        print('   📜 Response Headers: ${response.headers}'); // Added this
        print('   📦 Body: $bodyData');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return bodyData;
      }

      throw NetworkException(
        message: _messageFrom(bodyData) ?? 'File upload failed',
        statusCode: response.statusCode,
        data: bodyData,
      );
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw DeadlineExceededException();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String>> _authHeaders({required bool contentTypeJson}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    };
    if (contentTypeJson) {
      headers['Content-Type'] = 'application/json';
    }

    final token = await _session.getAccessToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      throw NetworkException(
        message: 'Session expired or invalid. Please login again.',
        statusCode: 401,
      );
    }

    return headers;
  }

  dynamic _decodeBody(String body) {
    if (body.trim().isEmpty) return null;
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  String _extractPathOrThrow(dynamic responseData) {
    final path = _extractSinglePath(responseData);
    if (path == null || path.isEmpty) {
      throw NetworkException(message: 'Upload succeeded but no image path returned');
    }
    return path;
  }

  String? _extractSinglePath(dynamic data) {
    if (data is String && data.isNotEmpty) return data;

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      const directKeys = ['path', 'file_path', 'image_path', 'url', 'file_url', 'full_path'];
      for (final key in directKeys) {
        final value = map[key];
        if (value is String && value.isNotEmpty) {
          return value;
        }
      }

      final nested = map['data'];
      final nestedPath = _extractSinglePath(nested);
      if (nestedPath != null && nestedPath.isNotEmpty) return nestedPath;
    }

    if (data is List) {
      for (final item in data) {
        final nestedPath = _extractSinglePath(item);
        if (nestedPath != null && nestedPath.isNotEmpty) {
          return nestedPath;
        }
      }
    }

    return null;
  }

  List<String> _extractMultiplePaths(dynamic data) {
    final paths = <String>[];

    void collect(dynamic value) {
      if (value is String && value.isNotEmpty) {
        paths.add(value);
        return;
      }
      if (value is Map) {
        const keys = ['path', 'file_path', 'image_path', 'url', 'file_url', 'full_path'];
        for (final key in keys) {
          final direct = value[key];
          if (direct is String && direct.isNotEmpty) {
            paths.add(direct);
          }
        }
        collect(value['data']);
        return;
      }
      if (value is List) {
        for (final item in value) {
          collect(item);
        }
      }
    }

    collect(data);
    return paths.toSet().toList();
  }

  String? _messageFrom(dynamic data) {
    if (data is Map) {
      return data['message']?.toString() ??
          data['msg']?.toString() ??
          data['error']?.toString();
    }
    return null;
  }
}

typedef _WebStoreEndpoints = WebStoreEndpoints;
