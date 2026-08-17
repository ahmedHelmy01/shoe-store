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
  static const Color primaryWine = Color(0xFF7B1E3B);
  static const Color textColor = Color(0xFF090F47);
  static const Color primaryBlueLight = Color(0xFFEDEFFB);
  static const Color baseScaffold = Color(0xFFE1E6F0);
  static const Color wine = Color(0xFF9C3353);
  static const Color darkWine = Color(0xFF5C1629);
  static const Color highlightWine = Color(0xFFB04A6C);
  static const Color boldWine = Color(0xFF8E2A4B);
  static const Color lightWine = Color(0xFFFBF2F6);

  // Core Tokens (Mapped to Brand Colors)
  static const Color primary = primaryWine;
  static const Color secondary = primaryBlue;
  static const Color accent = wine;
  
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
  static const LinearGradient primaryGradient = wineGradient;
  
  static const LinearGradient wineGradient = LinearGradient(
    colors: [primaryWine, wine],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
