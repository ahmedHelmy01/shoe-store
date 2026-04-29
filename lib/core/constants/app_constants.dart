import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Engineers Syndicate';

  // Design Tokens
  static const double borderRadius = 16.0;
  static const double paddingUnit = 8.0;

  // Assets
  static const String translationPath = 'assets/common/translations';

  // Network & Durations
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration duration3s = Duration(seconds: 3);
  static const Duration duration400 = Duration(milliseconds: 400);

  static const String arabicCode = 'ar';
  static const String englishCode = 'en';
  static const String localeKey = 'locale';
  static const String currency = 'ج.م'; // Egyptian Pound
}

class AppColors {
  // New Brand Colors
  static const Color primaryBlue = Color(0xFF465CA7);
  static const Color primaryOrange = Color(0xFFFF6D00);
  static const Color textColor = Color(0xFF090F47);
  static const Color primaryBlueLight = Color(0xFFEDEFFB);
  static const Color baseScaffold = Color(0xFFE1E6F0);
  static const Color orange = Color(0xFFF08320);
  static const Color darkOrange = Color(0xFFCF6212);
  static const Color highlightOrange = Color(0xFFFB8922);
  static const Color boldOrange = Color(0xFFEF5A56);
  static const Color lightOrange = Color(0xFFFFF9F4);

  // Core Tokens (Mapped to Brand Colors)
  static const Color primary = primaryOrange;
  static const Color secondary = primaryBlue;
  static const Color accent = orange;
  
  // Neutral
  static const Color background = baseScaffold;
  static const Color surface = Colors.white;
  static const Color surfaceLight = primaryBlueLight;

  // Text
  static const Color textMain = textColor;
  static const Color textSecondary = Color(0xFF5F6368);
  static const Color textHint = Color(0xFF9E9E9E);

  // Status
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFFBC02D);
  static const Color info = Color(0xFF0288D1);

  // Gradient
  static const LinearGradient primaryGradient = orangeGradient;
  
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [primaryOrange, orange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
