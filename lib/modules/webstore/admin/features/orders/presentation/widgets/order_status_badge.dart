import 'package:flutter/material.dart';

/// A styled badge that displays order status name with its color from the API.
/// This replaces the old hardcoded English-only OrderStatusDropdown for display.
class OrderStatusBadge extends StatelessWidget {
  final String status;
  final String? hexColor;
  final bool dense;

  const OrderStatusBadge({
    super.key,
    required this.status,
    this.hexColor,
    this.dense = false,
  });

  Color _parseColor() {
    if (hexColor == null || hexColor!.isEmpty) return Colors.blueGrey;
    try {
      final hex = hexColor!.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    final color = _parseColor();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 12,
        vertical: dense ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.4 : 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: dense ? 6 : 8,
            height: dense ? 6 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          SizedBox(width: dense ? 4 : 6),
          Flexible(
            child: Text(
              status,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: dense ? 11 : 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
