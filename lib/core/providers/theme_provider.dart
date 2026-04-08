import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';

/// Global Theme Provider using modern Riverpod Notifier
final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.light;
  }

  Future<void> _loadTheme() async {
    final isDark = await ref.read(sessionManagerProvider).isDarkMode();
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await ref.read(sessionManagerProvider).setDarkMode(true);
    } else {
      state = ThemeMode.light;
      await ref.read(sessionManagerProvider).setDarkMode(false);
    }
  }

  bool get isDarkMode => state == ThemeMode.dark;
}
