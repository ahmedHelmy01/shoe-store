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
    int? branchId,
  }) {
    return _networkService.post(
      ApiEndpoints.webstore.auth.register,
      body: {
        'name': name,
        'email': email,
        'mobile': mobile,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'company_id': 1, // Added for consistency
        if (branchId != null) 'branch_id': branchId,
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

  Future<dynamic> socialLogin({
    required String providerType,
    required String providerIdentifier,
    String? name,
    String? email,
    String? mobile,
    int? branchId,
  }) {
    return _networkService.post(
      ApiEndpoints.webstore.auth.socialLogin,
      body: {
        'provider_type': providerType,
        'provider_identifier': providerIdentifier,
        'company_id': 1, // Fixed to 1 as per user request
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (mobile != null) 'mobile': mobile,
        if (branchId != null) 'branch_id': branchId,
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

  // ─── Profile Operations ────────────────────────────

  Future<dynamic> getProfile() {
    return _networkService.get(
      ApiEndpoints.webstore.profile.profile,
    );
  }

  Future<dynamic> updateProfile({
    String? name,
    String? email,
    String? mobile,
    String? password,
  }) {
    return _networkService.put(
      ApiEndpoints.webstore.profile.profile,
      body: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (mobile != null) 'mobile': mobile,
        if (password != null) 'password': password,
      },
    );
  }

  Future<dynamic> deleteAccount() {
    return _networkService.delete(
      ApiEndpoints.webstore.profile.profile,
    );
  }
}
