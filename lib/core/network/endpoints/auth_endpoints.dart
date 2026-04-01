/// Authentication Endpoints
///
/// Contains all URLs related to the Auth module.
library;

class AuthEndpoints {
  const AuthEndpoints();

  final String login = '/api/auth/login';
  final String register = '/api/auth/register';
  final String logout = '/api/auth/logout';
  final String refreshToken = '/api/auth/refresh';
  final String forgotPassword = '/api/auth/forgot-password';
  final String resetPassword = '/api/auth/reset-password';
  final String verifyEmail = '/api/auth/verify-email';
  final String profile = '/api/auth/profile';
}
