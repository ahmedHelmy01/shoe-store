import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/network_check_internet.dart';
import 'package:erp/core/services/session_manager.dart';
// ... existing imports ...

// ... storage providers ...
/// SharedPreferences instance - must be initialized before app starts
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden with a valid instance',
  );
});

// Secure storage removed by request. Tokens are stored via `SessionManager`.

// ═══════════════════════════════════════════════════════════════
// 🌐 NETWORK PROVIDERS
// ═══════════════════════════════════════════════════════════════

/// HTTP Client instance
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

/// Network Service - Main HTTP wrapper (replaces ApiClient)
final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService(
    ref.watch(httpClientProvider),
    ref.watch(sessionManagerProvider),
  );
});

// ═══════════════════════════════════════════════════════════════
// 📡 CONNECTIVITY
// ═══════════════════════════════════════════════════════════════

/// Current connectivity status (Global)
final isConnectedProvider = Provider<bool>((ref) {
  return ref.watch(networkStatusProvider);
});

// ═══════════════════════════════════════════════════════════════
// 🔐 AUTH STATE (Modern Riverpod 3.0 Notifier)
// ═══════════════════════════════════════════════════════════════

/// Global authentication status
enum AuthStatus { initial, authenticated, unauthenticated }

/// Auth State Model
class AuthState {
  final AuthStatus status;
  final String? userId;
  final String? token;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userId,
    this.token,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? userId,
    String? token,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      token: token ?? this.token,
    );
  }
}

/// Global Auth State Provider
final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

/// Single SessionManager service (DI-friendly).
final sessionManagerProvider = Provider<SessionManager>((ref) {
  return SessionManager(
    prefs: ref.watch(sharedPreferencesProvider),
  );
});

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _init();
    return const AuthState();
  }

  Future<void> _init() async {
    final session = ref.read(sessionManagerProvider);
    final token = await session.getAccessToken();
    
    if (token != null && token.isNotEmpty) {
      final userId = await session.getUserId();
      state = AuthState(
        status: AuthStatus.authenticated,
        token: token,
        userId: userId,
      );
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> setAuthenticated({
    required String token,
    required String userId,
    String? refreshToken,
  }) async {
    final session = ref.read(sessionManagerProvider);
    await session.saveTokens(
      accessToken: token,
      refreshToken: refreshToken,
    );
    await session.saveUserId(userId);
    
    state = AuthState(
      status: AuthStatus.authenticated,
      token: token,
      userId: userId,
    );
  }

  Future<void> setUnauthenticated() async {
    final session = ref.read(sessionManagerProvider);
    await session.clearAuth();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}
