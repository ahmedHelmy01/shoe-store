import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:erp/core/config/env_config.dart';
import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/storage/secure_storage.dart';
import 'package:erp/core/network/network_check_internet.dart';
// ... existing imports ...

// ... storage providers ...
/// SharedPreferences instance - must be initialized before app starts
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden with a valid instance',
  );
});

/// Secure Storage - tokens and sensitive data
// ... next provider ...
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage(baseUrl: EnvConfig.baseUrl);
});

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
    ref.watch(secureStorageProvider),
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

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _init();
    return const AuthState();
  }

  Future<void> _init() async {
    final secureStorage = ref.read(secureStorageProvider);
    final token = await secureStorage.getAccessToken();
    
    if (token != null && token.isNotEmpty) {
      final userId = await secureStorage.getUserId();
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
    final secureStorage = ref.read(secureStorageProvider);
    await secureStorage.saveTokens(
      accessToken: token,
      refreshToken: refreshToken,
    );
    await secureStorage.saveUserId(userId);
    
    state = AuthState(
      status: AuthStatus.authenticated,
      token: token,
      userId: userId,
    );
  }

  Future<void> setUnauthenticated() async {
    final secureStorage = ref.read(secureStorageProvider);
    await secureStorage.clearAll();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}
