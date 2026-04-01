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
    final dynamic iconCodeValue = json['iconCode'];

    int iconCodeInt;
    if (iconCodeValue is int) {
      iconCodeInt = iconCodeValue;
    } else if (iconCodeValue is String) {
      iconCodeInt = int.parse(iconCodeValue.replaceFirst('0x', ''), radix: 16);
    } else {
      throw Exception("Invalid iconCode type");
    }
    return BottomNavItemConfig(
      icon: IconData(iconCodeInt, fontFamily: 'MaterialIcons'),
      label: json['label'] as String,
      route: json['route'] as String,
    );
  }
}
