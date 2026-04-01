import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Engineers Syndicate';

  // Design Tokens
  static const double borderRadius = 16.0;
  static const double paddingUnit = 8.0;

  // Assets
  static const String translationPath = 'assets/translations';

  // Network & Durations
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration duration3s = Duration(seconds: 3);
  static const Duration duration400 = Duration(milliseconds: 400);

  static const String arabicCode = 'ar';
  static const String englishCode = 'en';
  static const String localeKey = 'locale';
  static const String currency = 'ر.س'; // Saudi Riyal
}

class AppColors {
  // Green Palette
  static const Color primary = Color(0xFF1B5E20); // Deep Forest Green
  static const Color primaryLight = Color(0xFF2E7D32); // Vibrant Green
  static const Color primaryDark = Color(0xFF0A3D0A); // Darkest Green
  static const Color secondary = Color(0xFF66BB6A); // Light Green
  static const Color accent = Color(0xFF00E676); // Vivid Emerald

  // Extended Green Shades
  static const Color green50 = Color(0xFFE8F5E9);
  static const Color green100 = Color(0xFFC8E6C9);
  static const Color green200 = Color(0xFFA5D6A7);
  static const Color green300 = Color(0xFF81C784);
  static const Color green400 = Color(0xFF66BB6A);
  static const Color green500 = Color(0xFF4CAF50);
  static const Color green600 = Color(0xFF43A047);
  static const Color green700 = Color(0xFF388E3C);
  static const Color green800 = Color(0xFF2E7D32);
  static const Color green900 = Color(0xFF1B5E20);

  // Neutral
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);

  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Standard Theme Mapping (Light by Default)
  static const Color background = backgroundLight;
  static const Color surface = surfaceLight;
  
  // Text
  static const Color textMainLight = Color(0xFF202124);
  static const Color textSecondaryLight = Color(0xFF5F6368);
  static const Color textMainDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  static const Color textMain = textMainLight;
  static const Color textSecondary = textSecondaryLight;
  static const Color textHint = Color(0xFF9E9E9E); // Standard Hint Text Grey

  // Status
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFFBC02D);
  static const Color info = Color(0xFF0288D1);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
