import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';

/// 📶 Network Status Notifier (Modern Riverpod 3.0 Notifier)
///
/// Monitors device connectivity and internet availability.
final networkStatusProvider = NotifierProvider<NetworkStatusNotifier, bool>(() {
  return NetworkStatusNotifier();
});

class NetworkStatusNotifier extends Notifier<bool> {
  @override
  bool build() {
    _init();
    return true; // Assume connected initially
  }

  void _init() {
    final subscription = Connectivity().onConnectivityChanged.listen((result) async {
      bool isConnected = await _checkInternet();
      state = isConnected;
    });
    
    // Manage resource lifecycle
    ref.onDispose(() => subscription.cancel());
    
    _checkInternet().then((value) => state = value);
  }

  Future<bool> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(AppConstants.duration3s);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
