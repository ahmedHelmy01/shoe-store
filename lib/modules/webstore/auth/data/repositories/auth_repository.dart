/// WebStore Auth Repository
///
/// Provides a clean interface for all WebStore authentication operations.
/// Uses BaseRepository.safeApiCall for consistent error handling.
library;

import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/auth/data/datasource/webstore_auth_remote_datasource.dart';
import 'package:erp/modules/webstore/auth/data/models/webstore_auth_response.dart';

// ─── Interface ────────────────────────────────────────

abstract class IWebStoreAuthRepository {
  Future<ApiResult<WebStoreAuthResponse>> register({
    required String name,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
    int? branchId,
  });

  Future<ApiResult<WebStoreAuthResponse>> login({
    required String loginName,
    required String password,
  });

  Future<ApiResult<Map<String, dynamic>>> forgotPassword({
    required String username,
  });

  Future<ApiResult<Map<String, dynamic>>> verifyCode({
    required String identifier,
    required String code,
    required String type,
  });

  Future<ApiResult<Map<String, dynamic>>> resendCode({
    required String identifier,
    required String type,
  });

  Future<ApiResult<Map<String, dynamic>>> resetPassword({
    required String identifier,
    required String code,
    required String password,
    required String passwordConfirmation,
  });

  Future<ApiResult<WebStoreAuthResponse>> refreshToken();

  Future<ApiResult<Map<String, dynamic>>> getProfile();

  Future<ApiResult<Map<String, dynamic>>> updateProfile({
    String? name,
    String? email,
    String? mobile,
    String? password,
  });

  Future<ApiResult<Map<String, dynamic>>> deleteAccount();
}

// ─── Implementation ──────────────────────────────────

class WebStoreAuthRepository extends BaseRepository
    implements IWebStoreAuthRepository {
  final WebStoreAuthRemoteDataSource _dataSource;

  WebStoreAuthRepository(this._dataSource);

  @override
  Future<ApiResult<WebStoreAuthResponse>> register({
    required String name,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
    int? branchId,
  }) {
    return safeApiCall<WebStoreAuthResponse>(() async {
      final response = await _dataSource.register(
        name: name,
        email: email,
        mobile: mobile,
        password: password,
        passwordConfirmation: passwordConfirmation,
        branchId: branchId,
      );
      return WebStoreAuthResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<ApiResult<WebStoreAuthResponse>> login({
    required String loginName,
    required String password,
  }) {
    return safeApiCall<WebStoreAuthResponse>(() async {
      final response = await _dataSource.login(
        loginName: loginName,
        password: password,
      );
      return WebStoreAuthResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> forgotPassword({
    required String username,
  }) {
    return safeApiCall<Map<String, dynamic>>(
      () async {
        final response = await _dataSource.forgotPassword(username: username);
        return response as Map<String, dynamic>;
      },
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> verifyCode({
    required String identifier,
    required String code,
    required String type,
  }) {
    return safeApiCall<Map<String, dynamic>>(
      () async {
        final response = await _dataSource.verifyCode(
          identifier: identifier,
          code: code,
          type: type,
        );
        return response as Map<String, dynamic>;
      },
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> resendCode({
    required String identifier,
    required String type,
  }) {
    return safeApiCall<Map<String, dynamic>>(
      () async {
        final response = await _dataSource.resendCode(
          identifier: identifier,
          type: type,
        );
        return response as Map<String, dynamic>;
      },
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> resetPassword({
    required String identifier,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) {
    return safeApiCall<Map<String, dynamic>>(
      () async {
        final response = await _dataSource.resetPassword(
          identifier: identifier,
          code: code,
          password: password,
          passwordConfirmation: passwordConfirmation,
        );
        return response as Map<String, dynamic>;
      },
    );
  }

  @override
  Future<ApiResult<WebStoreAuthResponse>> refreshToken() {
    return safeApiCall<WebStoreAuthResponse>(
      () async {
        final response = await _dataSource.refreshToken();
        return WebStoreAuthResponse.fromJson(response as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getProfile() {
    return safeApiCall<Map<String, dynamic>>(
      () async {
        final response = await _dataSource.getProfile();
        return response as Map<String, dynamic>;
      },
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> updateProfile({
    String? name,
    String? email,
    String? mobile,
    String? password,
  }) {
    return safeApiCall<Map<String, dynamic>>(
      () async {
        final response = await _dataSource.updateProfile(
          name: name,
          email: email,
          mobile: mobile,
          password: password,
        );
        return response as Map<String, dynamic>;
      },
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> deleteAccount() {
    return safeApiCall<Map<String, dynamic>>(
      () async {
        final response = await _dataSource.deleteAccount();
        return response as Map<String, dynamic>;
      },
    );
  }
}
