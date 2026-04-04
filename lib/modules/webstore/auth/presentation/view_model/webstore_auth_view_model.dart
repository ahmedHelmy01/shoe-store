/// WebStore Auth ViewModel
///
/// Manages the authentication state for WebStore module.
/// Handles: register, login, forgot-password, verify-code, resend-code.
/// Uses modern Riverpod 3.0 Notifier pattern.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/auth/data/repositories/auth_repository.dart';
import 'package:erp/modules/webstore/auth/presentation/state/webstore_auth_state.dart';
import 'package:erp/modules/webstore/auth/presentation/view_model/webstore_auth_providers.dart';

class WebStoreAuthViewModel extends Notifier<WebStoreAuthState> {
  @override
  WebStoreAuthState build() => const WebStoreAuthIdle();

  IWebStoreAuthRepository get _repository =>
      ref.read(webStoreAuthRepositoryProvider);

  // ─── Register ──────────────────────────────────────

  Future<void> register({
    required String name,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = const WebStoreAuthLoading();

    final result = await _repository.register(
      name: name,
      email: email,
      mobile: mobile,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    result.when(
      success: (authResponse) async {
        // Save token to secure storage
        await ref.read(secureStorageProvider).saveTokens(
              accessToken: authResponse.token,
            );
        await ref.read(secureStorageProvider).saveUserId(
              authResponse.user.id.toString(),
            );

        // Update global auth state
        ref.read(authStateProvider.notifier).setAuthenticated(
              token: authResponse.token,
              userId: authResponse.user.id.toString(),
            );

        state = WebStoreAuthSuccess(authResponse);
      },
      failure: (exception) {
        state = WebStoreAuthError(exception.message);
      },
    );
  }

  // ─── Login ─────────────────────────────────────────

  Future<void> login({
    required String loginName,
    required String password,
  }) async {
    state = const WebStoreAuthLoading();

    final result = await _repository.login(
      loginName: loginName,
      password: password,
    );

    result.when(
      success: (authResponse) async {
        // Save token to secure storage
        await ref.read(secureStorageProvider).saveTokens(
              accessToken: authResponse.token,
            );
        await ref.read(secureStorageProvider).saveUserId(
              authResponse.user.id.toString(),
            );

        // Update global auth state
        ref.read(authStateProvider.notifier).setAuthenticated(
              token: authResponse.token,
              userId: authResponse.user.id.toString(),
            );

        state = WebStoreAuthSuccess(authResponse);
      },
      failure: (exception) {
        state = WebStoreAuthError(exception.message);
      },
    );
  }

  // ─── Forgot Password ──────────────────────────────

  Future<void> forgotPassword({
    required String username,
  }) async {
    state = const WebStoreAuthLoading();

    final result = await _repository.forgotPassword(username: username);

    result.when(
      success: (data) {
        final message = data['message'] as String? ?? 'تم إرسال كود التحقق';
        state = WebStoreOtpSent(
          message: message,
          identifier: username,
          type: 'password_reset',
        );
      },
      failure: (exception) {
        state = WebStoreAuthError(exception.message);
      },
    );
  }

  // ─── Verify Code ───────────────────────────────────

  Future<void> verifyCode({
    required String identifier,
    required String code,
    required String type,
  }) async {
    state = const WebStoreAuthLoading();

    final result = await _repository.verifyCode(
      identifier: identifier,
      code: code,
      type: type,
    );

    result.when(
      success: (data) {
        final message = data['message'] as String? ?? 'تم التحقق بنجاح';
        state = WebStoreOtpVerified(message);
      },
      failure: (exception) {
        state = WebStoreAuthError(exception.message);
      },
    );
  }

  // ─── Resend Code ───────────────────────────────────

  Future<void> resendCode({
    required String identifier,
    required String type,
  }) async {
    state = const WebStoreAuthLoading();

    final result = await _repository.resendCode(
      identifier: identifier,
      type: type,
    );

    result.when(
      success: (data) {
        final message = data['message'] as String? ?? 'تم إعادة إرسال الكود';
        state = WebStoreOtpResent(message);
      },
      failure: (exception) {
        state = WebStoreAuthError(exception.message);
      },
    );
  }

  // ─── Reset Password ─────────────────────────────

  Future<void> resetPassword({
    required String identifier,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = const WebStoreAuthLoading();

    final result = await _repository.resetPassword(
      identifier: identifier,
      code: code,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    result.when(
      success: (data) {
        final message = data['message'] as String? ?? 'تم تغيير كلمة المرور بنجاح';
        state = WebStoreAuthPasswordResetSuccess(message);
      },
      failure: (exception) {
        state = WebStoreAuthError(exception.message);
      },
    );
  }

  // ─── Refresh Token ─────────────────────────────────

  Future<void> refreshToken() async {
    final result = await _repository.refreshToken();

    result.when(
      success: (authResponse) async {
        await ref.read(secureStorageProvider).saveTokens(
              accessToken: authResponse.token,
            );
        state = WebStoreAuthSuccess(authResponse);
      },
      failure: (exception) {
        // Handle token refresh failure (e.g., logout)
        ref.read(authStateProvider.notifier).setUnauthenticated();
      },
    );
  }

  // ─── Reset to Idle ─────────────────────────────────

  void resetState() {
    state = const WebStoreAuthIdle();
  }
}
