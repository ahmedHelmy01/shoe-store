import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/config/app_config_manager.dart';

/// 📶 Network Status Notifier (Modern Riverpod 3.0 Notifier)
///
/// Monitors device connectivity and internet availability.
///
/// **Key improvements over the previous implementation:**
/// - **Debouncing**: Waits before reacting to connectivity changes to avoid
///   false negatives from transient OS events (Android Doze, Wi-Fi handoff).
/// - **Retry logic**: Attempts DNS lookup multiple times before declaring
///   the device offline.
/// - **App lifecycle awareness**: Re-checks connectivity when the app resumes
///   from background to handle Doze-mode recovery.
final networkStatusProvider = NotifierProvider<NetworkStatusNotifier, bool>(() {
  return NetworkStatusNotifier();
});

class NetworkStatusNotifier extends Notifier<bool> {
  Timer? _debounceTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // ─── Configuration ────────────────────────────────────────────
  /// How long to wait after a connectivity event before checking internet.
  /// This absorbs rapid-fire events from Android Doze / Wi-Fi fluctuations.
  static const _debounceDisconnect = Duration(seconds: 3);

  /// Shorter debounce when connectivity is restored (user expects fast feedback).
  static const _debounceReconnect = Duration(seconds: 1);

  /// Max number of DNS-lookup retries before declaring offline.
  static const _maxRetries = 3;

  /// Delay between retry attempts.
  static const _retryDelay = Duration(seconds: 1);

  // ─── Lifecycle ────────────────────────────────────────────────

  @override
  bool build() {
    _init();
    return true; // Assume connected initially
  }

  void _init() {
    // Listen to OS connectivity changes with debouncing
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);

    // Register the app-lifecycle observer so we re-check after Doze
    final observer = _AppLifecycleObserver(onResumed: _onAppResumed);
    WidgetsBinding.instance.addObserver(observer);

    // Clean up resources on provider dispose
    ref.onDispose(() {
      _connectivitySubscription?.cancel();
      _debounceTimer?.cancel();
      WidgetsBinding.instance.removeObserver(observer);
    });

    // Initial check (no debounce needed)
    _checkWithRetry();
  }

  // ─── Event Handlers ───────────────────────────────────────────

  /// Called whenever the OS reports a connectivity change.
  void _onConnectivityChanged(List<ConnectivityResult> results) {
    _debounceTimer?.cancel();

    final isNone = results.contains(ConnectivityResult.none);

    // Use a longer debounce for disconnects (could be transient),
    // and a shorter one for reconnects (user wants quick feedback).
    final delay = isNone ? _debounceDisconnect : _debounceReconnect;

    _debounceTimer = Timer(delay, () => _checkWithRetry());
  }

  /// Called when the app returns to the foreground (e.g. after Doze).
  void _onAppResumed() {
    // Quick re-check — the OS may have restored connectivity.
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceReconnect, () => _checkWithRetry());
  }

  // ─── Internet Verification ────────────────────────────────────

  /// Performs up to [_maxRetries] DNS lookups before setting state to false.
  Future<void> _checkWithRetry() async {
    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      final isConnected = await _checkInternet();
      if (isConnected) {
        state = true;
        return;
      }
      // Wait before the next attempt (skip delay after the last attempt)
      if (attempt < _maxRetries - 1) {
        await Future.delayed(_retryDelay);
      }
    }
    // All retries exhausted — mark as disconnected
    state = false;
  }

  /// Single DNS-lookup attempt against the backend host, then google.com.
  Future<bool> _checkInternet() async {
    // 1. Try to resolve the backend host since that's what the app interacts with.
    //    This also solves emulator DNS issues for external sites like google.com.
    try {
      final host = Uri.parse(AppConfigManager.instance.baseURL).host;
      if (host.isNotEmpty) {
        final result = await InternetAddress.lookup(host)
            .timeout(AppConstants.duration3s);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      }
    } catch (_) {}

    // 2. Fallback to google.com if backend check fails
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(AppConstants.duration3s);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// Private lifecycle observer — re-checks internet when app resumes
// ═══════════════════════════════════════════════════════════════════

class _AppLifecycleObserver extends WidgetsBindingObserver {
  final VoidCallback onResumed;
  _AppLifecycleObserver({required this.onResumed});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    }
  }
}
