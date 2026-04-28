import 'package:flutter/material.dart';

class AdminDefaultBadge extends StatelessWidget {
  final bool isDefault;
  final String label;

  const AdminDefaultBadge({
    super.key,
    required this.isDefault,
    this.label = 'Default',
  });

  @override
  Widget build(BuildContext context) {
    if (!isDefault) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // A nice premium green badge
    final greenColor = isDark ? const Color(0xFF10B981) : const Color(0xFF059669);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: greenColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: greenColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, size: 14, color: greenColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: greenColor,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
