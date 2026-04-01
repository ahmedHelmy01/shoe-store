import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'EduTrack';

  // Design Tokens
  static const double borderRadius = 16.0;
  static const double paddingUnit = 8.0;

  // Assets
  static const String translationPath = 'assets/translations';
}

class AppColors {
  // From provided mockup
  static const Color primary = Color(0xFF5E5CE6);
  static const Color primaryLight = Color(0xFF7D7AFF);
  static const Color secondary = Color(0xFFAD52E2);
  static const Color accent = Color(0xFFBF5AF2);

  static const Color background = Color(0xFFF2F2F7);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textMain = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textHint = Color(0xFFC7C7CC);

  static const Color error = Color(0xFFFF3B30);
  static const Color success = Color(0xFF34C759);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4E4CF7), Color(0xFFAD52E2)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
