import 'package:flutter/material.dart';

class OrderSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  final bool emphasize;
  final bool muted;

  const OrderSummaryRow({
    super.key,
    required this.label,
    required this.value,
    required this.theme,
    this.emphasize = false,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)
        : theme.textTheme.bodyMedium?.copyWith(
            color: muted ? theme.hintColor : null,
          );
    final vStyle = emphasize
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)
        : theme.textTheme.bodyMedium?.copyWith(
            color: muted ? theme.hintColor : null,
            fontWeight: FontWeight.w700,
          );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(value, style: vStyle),
        ],
      ),
    );
  }
}
