/// WebStore Auth State
///
/// Sealed class hierarchy for WebStore authentication states.
/// Used with StateNotifier pattern in Riverpod.
library;

import 'package:erp/modules/webstore/auth/data/models/webstore_auth_response.dart';

sealed class WebStoreAuthState {
  const WebStoreAuthState();
}

/// Initial idle state
class WebStoreAuthIdle extends WebStoreAuthState {
  const WebStoreAuthIdle();
}

/// Loading state (API call in progress)
class WebStoreAuthLoading extends WebStoreAuthState {
  const WebStoreAuthLoading();
}

/// Login/Register success - contains user data and token
class WebStoreAuthSuccess extends WebStoreAuthState {
  final WebStoreAuthResponse authResponse;
  const WebStoreAuthSuccess(this.authResponse);
}

/// Error state with message
class WebStoreAuthError extends WebStoreAuthState {
  final String message;
  const WebStoreAuthError(this.message);
}

/// OTP sent successfully (forgot password / registration verification)
class WebStoreOtpSent extends WebStoreAuthState {
  final String message;
  final String identifier;
  final String type;
  const WebStoreOtpSent({
    required this.message,
    required this.identifier,
    required this.type,
  });
}

/// OTP verified successfully
class WebStoreOtpVerified extends WebStoreAuthState {
  final String message;
  const WebStoreOtpVerified(this.message);
}

/// OTP resent successfully
class WebStoreOtpResent extends WebStoreAuthState {
  final String message;
  const WebStoreOtpResent(this.message);
}

/// Password reset successfully
class WebStoreAuthPasswordResetSuccess extends WebStoreAuthState {
  final String message;
  const WebStoreAuthPasswordResetSuccess(this.message);
}
