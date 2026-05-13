/// WebStore Auth ViewModel
///
/// Manages the authentication state for WebStore module.
/// Handles: register, login, forgot-password, verify-code, resend-code.
/// Uses modern Riverpod 3.0 Notifier pattern.
library;

import 'package:erp/modules/webstore/auth/data/models/webstore_auth_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/auth/data/repositories/auth_repository.dart';
import 'package:erp/modules/webstore/auth/presentation/state/webstore_auth_state.dart';
import 'package:erp/modules/webstore/auth/presentation/view_model/webstore_auth_providers.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class WebStoreAuthViewModel extends Notifier<WebStoreAuthState> {
  @override
  WebStoreAuthState build() => const WebStoreAuthIdle();

  IWebStoreAuthRepository get _repository =>
      ref.read(webStoreAuthRepositoryProvider);

  GoogleSignIn get _googleSignIn => GoogleSignIn.instance;

  // ─── Register ──────────────────────────────────────

  Future<void> register({
    required String name,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
    int? branchId,
  }) async {
    state = const WebStoreAuthLoading();

    final result = await _repository.register(
      name: name,
      email: email,
      mobile: mobile,
      password: password,
      passwordConfirmation: passwordConfirmation,
      branchId: branchId,
    );

    result.when(
      success: (authResponse) async {
        // Save token to session storage
        await ref
            .read(sessionManagerProvider)
            .saveTokens(accessToken: authResponse.token);
        await ref
            .read(sessionManagerProvider)
            .saveUserId(authResponse.user.id.toString());

        // Update global auth state
        ref
            .read(authStateProvider.notifier)
            .setAuthenticated(
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
        await ref
            .read(sessionManagerProvider)
            .saveTokens(accessToken: authResponse.token);
        await ref
            .read(sessionManagerProvider)
            .saveUserId(authResponse.user.id.toString());
        ref
            .read(authStateProvider.notifier)
            .setAuthenticated(
              token: authResponse.token,
              userId: authResponse.user.id.toString(),
            );
        state = WebStoreAuthSuccess(authResponse);
      },
      failure: (exception) => state = WebStoreAuthError(exception.message),
    );
  }

  // ─── Social Login ────────────────────────────────────

  Future<void> socialLogin({
    required String providerType,
    required String
    providerIdentifier, // This will be ignored for real login if handled here
    String? name,
    String? email,
    String? mobile,
    int? branchId,
  }) async {
    state = const WebStoreAuthLoading();

    try {
      String? realId = providerIdentifier;
      String? realName = name;
      String? realEmail = email;

      if (providerType == 'google') {
        final GoogleSignInAccount? googleUser = await _googleSignIn
            .authenticate();
        if (googleUser == null) {
          state = const WebStoreAuthIdle();
          return; // User cancelled
        }
        realId = googleUser.id;
        realName = googleUser.displayName;
        realEmail = googleUser.email;
      } else if (providerType == 'facebook') {
        final LoginResult fbResult = await FacebookAuth.instance.login();
        if (fbResult.status == LoginStatus.success) {
          final userData = await FacebookAuth.instance.getUserData();
          realId = userData['id'];
          realName = userData['name'];
          realEmail = userData['email'];
        } else {
          state = const WebStoreAuthIdle();
          return; // User cancelled or error
        }
      }

      if (realId == null) {
        state = const WebStoreAuthIdle();
        return;
      }

      final result = await _repository.socialLogin(
        providerType: providerType,
        providerIdentifier: realId,
        name: realName,
        email: realEmail,
        mobile: mobile,
        branchId: branchId,
      );

      result.when(
        success: (authResponse) async {
          await ref
              .read(sessionManagerProvider)
              .saveTokens(accessToken: authResponse.token);
          await ref
              .read(sessionManagerProvider)
              .saveUserId(authResponse.user.id.toString());
          ref
              .read(authStateProvider.notifier)
              .setAuthenticated(
                token: authResponse.token,
                userId: authResponse.user.id.toString(),
              );
          state = WebStoreAuthSuccess(authResponse);
        },
        failure: (exception) => state = WebStoreAuthError(exception.message),
      );
    } catch (e) {
      state = WebStoreAuthError(e.toString());
    }
  }

  // ─── Forgot Password ──────────────────────────────

  Future<void> forgotPassword({required String username}) async {
    state = const WebStoreAuthLoading();

    final result = await _repository.forgotPassword(username: username);

    result.when(
      success: (data) {
        final message =
            data['message'] as String? ??
            LocaleKeys.webstore.auth.otp_sent.tr();
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
        final message =
            data['message'] as String? ??
            LocaleKeys.webstore.auth.otp_verified.tr();
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
        final message =
            data['message'] as String? ??
            LocaleKeys.webstore.auth.otp_resent.tr();
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
        final message =
            data['message'] as String? ??
            LocaleKeys.webstore.auth.password_reset_success.tr();
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
        await ref
            .read(sessionManagerProvider)
            .saveTokens(accessToken: authResponse.token);
        state = WebStoreAuthSuccess(authResponse);
      },
      failure: (exception) {
        // Handle token refresh failure (e.g., logout)
        ref.read(authStateProvider.notifier).setUnauthenticated();
      },
    );
  }

  // ─── Profile Operations ────────────────────────────

  Future<void> getProfile() async {
    state = const WebStoreAuthLoading();
    final result = await _repository.getProfile();
    result.when(
      success: (data) {
        // We can reuse WebStoreAuthSuccess or create a new state
        // For simplicity, let's keep it in Success but we need to handle it in UI
        state = WebStoreAuthSuccess(WebStoreAuthResponse.fromJson(data));
      },
      failure: (exception) {
        state = WebStoreAuthError(exception.message);
      },
    );
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? mobile,
    String? password,
  }) async {
    state = const WebStoreAuthLoading();
    final result = await _repository.updateProfile(
      name: name,
      email: email,
      mobile: mobile,
      password: password,
    );
    result.when(
      success: (data) async {
        final message =
            data['message'] as String? ?? 'Profile updated successfully';
        // Refresh profile data to get the updated user object
        await getProfile();
        // We can show the message using a different mechanism or keep the success state
        state = WebStoreOtpVerified(message);
      },
      failure: (exception) {
        state = WebStoreAuthError(exception.message);
      },
    );
  }

  Future<void> deleteAccount() async {
    state = const WebStoreAuthLoading();
    final result = await _repository.deleteAccount();
    result.when(
      success: (data) async {
        await ref.read(sessionManagerProvider).clearSession();
        ref.read(authStateProvider.notifier).setUnauthenticated();
        state = const WebStoreAuthIdle();
      },
      failure: (exception) {
        state = WebStoreAuthError(exception.message);
      },
    );
  }

  // ─── Reset to Idle ─────────────────────────────────

  void resetState() {
    state = const WebStoreAuthIdle();
  }
}
