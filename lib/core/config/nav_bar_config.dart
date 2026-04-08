import 'package:flutter/material.dart';

class BottomNavItemConfig {
  final IconData icon;
  final String label;
  final String route;

  const BottomNavItemConfig({
    required this.icon,
    required this.label,
    required this.route,
  });

  factory BottomNavItemConfig.fromJson(Map<String, dynamic> json) {
    return BottomNavItemConfig(
      // IMPORTANT:
      // Avoid constructing IconData at runtime for web release builds with icon tree shaking.
      // We keep a small, safe mapping of supported icons.
      icon: _materialIconFromCode(json['iconCode']),
      label: json['label'] as String,
      route: json['route'] as String,
    );
  }
}

IconData _materialIconFromCode(dynamic iconCodeValue) {
  int? code;
  if (iconCodeValue is int) {
    code = iconCodeValue;
  } else if (iconCodeValue is String) {
    code = int.tryParse(iconCodeValue.replaceFirst('0x', ''), radix: 16);
  }

  // Add mappings here as needed.
  switch (code) {
    default:
      return Icons.circle_outlined;
  }
}
