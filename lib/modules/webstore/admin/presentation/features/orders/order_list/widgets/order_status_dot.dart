import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';

class OrderStatusDot extends StatelessWidget {
  final String status;
  final bool small;

  const OrderStatusDot({super.key, required this.status, this.small = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final r = small ? 4.0 : 5.0;

    final color = switch (status.toLowerCase()) {
      'delivered' => const Color(0xFF0A7A3D),
      'shipped' => const Color(0xFF1D4ED8),
      'processing' => const Color(0xFF7C3AED),
      'cancelled' => const Color(0xFFB42318),
      _ => AppColors.primaryOrange,
    };

    return Container(
      width: r * 2,
      height: r * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: isDark ? 0.45 : 0.25),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.75 : 0.45),
        ),
      ),
    );
  }
}
