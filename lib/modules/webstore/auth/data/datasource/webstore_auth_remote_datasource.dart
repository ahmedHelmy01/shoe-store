/// WebStore Auth Remote DataSource
///
/// Handles all HTTP calls to the WebStore Auth API endpoints.
/// Endpoints: register, login, forgot-password, verify-code, resend-code.
library;

import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class WebStoreAuthRemoteDataSource {
  final NetworkService _networkService;

  WebStoreAuthRemoteDataSource(this._networkService);

  // ─── Register ──────────────────────────────────────

  Future<dynamic> register({
    required String name,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
  }) {
    return _networkService.post(
      ApiEndpoints.webstore.auth.register,
      body: {
        'name': name,
        'email': email,
        'mobile': mobile,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }

  // ─── Login ─────────────────────────────────────────

  Future<dynamic> login({
    required String loginName,
    required String password,
  }) {
    return _networkService.post(
      ApiEndpoints.webstore.auth.login,
      body: {
        // API expects "username" (email/mobile)
        'username': loginName,
        'password': password,
      },
    );
  }

  // ─── Forgot Password ──────────────────────────────

  Future<dynamic> forgotPassword({
    required String username,
  }) {
    return _networkService.post(
      ApiEndpoints.webstore.auth.forgotPassword,
      body: {
        'username': username,
      },
    );
  }

  // ─── Verify Code ───────────────────────────────────

  Future<dynamic> verifyCode({
    required String identifier,
    required String code,
    required String type,
  }) {
    return _networkService.post(
      ApiEndpoints.webstore.auth.verifyCode,
      body: {
        'identifier': identifier,
        'code': code,
        'type': type,
      },
    );
  }

  // ─── Resend Code ───────────────────────────────────

  Future<dynamic> resendCode({
    required String identifier,
    required String type,
  }) {
    return _networkService.post(
      ApiEndpoints.webstore.auth.resendCode,
      body: {
        'identifier': identifier,
        'type': type,
      },
    );
  }

  // ─── Reset Password ─────────────────────────────

  Future<dynamic> resetPassword({
    required String identifier,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) {
    return _networkService.post(
      ApiEndpoints.webstore.auth.resetPassword,
      body: {
        'identifier': identifier,
        'code': code,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }

  // ─── Refresh Token ─────────────────────────────────

  Future<dynamic> refreshToken() {
    return _networkService.post(
      ApiEndpoints.webstore.auth.refreshToken,
    );
  }
}
