import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:freerasp/freerasp.dart';
import 'package:erp/core/constants/app_constants.dart';

/// A professional security layer designed to protect the app from:
/// 1. Root/Jailbreak
/// 2. Code Injection & Hooking (Frida, etc.)
/// 3. Debugging attempts
/// 4. Emulators (Optional)
class SecurityService {
  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();

  /// Initialize security checks.
  /// 
  /// [forceCloseOnThreat] If true, the app will terminate if a threat is detected.
  Future<void> init({bool forceCloseOnThreat = !kDebugMode}) async {
    if (kIsWeb) {
      // Web protection is primarily handled via index.html scripts
      return;
    }

    // Talsec / freeRASP Configuration
    // These would typically be retrieved from a secure config or Talsec dashboard
    final config = TalsecConfig(
      androidConfig: AndroidConfig(
        packageName: 'com.tarshouby.erp', // Replace with actual package name
        signingCertHashes: ['YOUR_CERT_HASH'], // Required for tampering protection
      ),
      iosConfig: IOSConfig(
        bundleIds: ['com.tarshouby.erp'],
        teamId: 'YOUR_TEAM_ID',
      ),
      watcherMail: 'security@tarshouby.com',
    );

    // Talsec / freeRASP Callback
    final callback = ThreatCallback(
      onPrivilegedAccess: () => _handleThreat('Root/Jailbreak Detected', forceCloseOnThreat),
      onDebug: () => _handleThreat('Debugger Attached', forceCloseOnThreat),
      onAppIntegrity: () => _handleThreat('App Tampering Detected', forceCloseOnThreat),
      onHooks: () => _handleThreat('Hooking Framework Detected', forceCloseOnThreat),
      onSimulator: () => _handleThreat('Simulator Detected', forceCloseOnThreat),
      onDeviceBinding: () => _handleThreat('Device Binding Violation', forceCloseOnThreat),
      onUnofficialStore: () => _handleThreat('Unofficial Store Detected', forceCloseOnThreat),
    );

    // Attach listener before starting
    Talsec.instance.attachListener(callback);

    try {
      await Talsec.instance.start(config);
      debugPrint('🛡️ Security Service Initialized Successfully');
    } catch (e) {
      debugPrint('❌ Failed to start Security Service: $e');
    }
  }

  void _handleThreat(String threatType, bool forceClose) {
    debugPrint('🚨 SECURITY THREAT: $threatType');
    
    if (forceClose) {
      debugPrint('⛔ Terminating app due to security threat...');
      exit(0);
    }
  }
}
