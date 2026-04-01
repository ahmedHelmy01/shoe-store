import 'package:flutter/material.dart';

class LoggingObserver extends NavigatorObserver {
  void _logStack(BuildContext? context, String label) {
    // Hidden for production
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint(
        'Navigation: Push ${route.settings.name} (Previous: ${previousRoute?.settings.name})');
    if (navigator?.context != null) {
      _logStack(navigator!.context, 'AFTER PUSH');
    }

    if (route.settings.name == 'ProductDetail2Route') {
      // Trace removed
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint(
        'Navigation: Pop ${route.settings.name} (Previous: ${previousRoute?.settings.name})');
    if (navigator?.context != null) {
      _logStack(navigator!.context, 'AFTER POP');
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('Navigation: Remove ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    debugPrint(
        'Navigation: Replace ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
  }
}
