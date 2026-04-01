import 'package:flutter/material.dart';

class CustomThemeConfig {
  final Color primaryColor;
  final Color primaryColorDark;
  final Color primaryColorLight;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color errorColor;
  final Color successColor;
  final Color warningColor;
  final Color bottomNavBackground;
  final Color bottomNavSelected;
  final Color bottomNavUnselected;
  final Color linearGradientHome;
  final double? smallTextFontSize;
  final double? sectionTitleFontSize;
  final double? buttonTextFontSize;
  final FontWeight? buttonTextFontWeight;
  final Color? buttonTextColor;
  final double borderRadius;
  final double cardElevation;
  final double buttonHeight;
  final bool isDarkMode;
  final Color textColor;
  final Color appBarTextColor;
  const CustomThemeConfig({
    required this.primaryColor,
    required this.primaryColorDark,
    required this.primaryColorLight,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.errorColor,
    required this.successColor,
    required this.warningColor,
    required this.bottomNavBackground,
    required this.bottomNavSelected,
    required this.bottomNavUnselected,
    required this.linearGradientHome,
    this.smallTextFontSize,
    this.sectionTitleFontSize,
    this.buttonTextFontSize,
    this.buttonTextFontWeight,
    this.buttonTextColor,
    this.borderRadius = 8.0,
    this.cardElevation = 2.0,
    this.buttonHeight = 48.0,
    this.isDarkMode = false,
    required this.textColor,
    required this.appBarTextColor,
  });

  factory CustomThemeConfig.fromJson(Map<String, dynamic> json) =>
      CustomThemeConfig(
        primaryColor: _parseColor(json['primaryColor']),
        primaryColorDark: _parseColor(json['primaryColorDark']),
        primaryColorLight: _parseColor(json['primaryColorLight']),
        secondaryColor: _parseColor(json['secondaryColor']),
        backgroundColor: _parseColor(json['backgroundColor']),
        surfaceColor: _parseColor(json['surfaceColor']),
        errorColor: _parseColor(json['errorColor']),
        successColor: _parseColor(json['successColor']),
        warningColor: _parseColor(json['warningColor']),
        bottomNavBackground: _parseColor(json['bottomNavBackground']),
        bottomNavSelected: _parseColor(json['bottomNavSelected']),
        bottomNavUnselected: _parseColor(json['bottomNavUnselected']),
        linearGradientHome: _parseColor(json['linearGradientHome']),
        smallTextFontSize: json['smallTextFontSize']?.toDouble(),
        sectionTitleFontSize: json['sectionTitleFontSize']?.toDouble(),
        buttonTextFontSize: json['buttonTextFontSize']?.toDouble(),
        buttonTextFontWeight: json['buttonTextFontWeight'] != null
            ? FontWeight.values[json['buttonTextFontWeight']]
            : null,
        buttonTextColor: json['buttonTextColor'] != null
            ? _parseColor(json['buttonTextColor'])
            : null,
        borderRadius: (json['borderRadius'] ?? 8.0).toDouble(),
        cardElevation: (json['cardElevation'] ?? 2.0).toDouble(),
        buttonHeight: (json['buttonHeight'] ?? 48.0).toDouble(),
        isDarkMode: json['isDarkMode'] ?? false,
        textColor: _parseColor(json['textColor']),
        appBarTextColor: _parseColor(json['appBarTextColor']),
      );

// Helper function to parse color
  static Color _parseColor(dynamic value) {
    if (value == null) return Colors.transparent;

    if (value is int) return Color(value);
    if (value is String) {
      String colorStr =
          value.toUpperCase().replaceAll("#", "").replaceAll("0X", "");
      if (colorStr.length == 6) colorStr = "FF$colorStr";
      return Color(int.parse(colorStr, radix: 16));
    }
    return Colors.transparent;
  }
}
