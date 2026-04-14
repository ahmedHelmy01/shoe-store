import 'dart:math';
import 'package:flutter/material.dart';

class AdminDataTableFooter extends StatelessWidget {
  final int page;
  final int pageCount;
  final int pageSize;
  final int total;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const AdminDataTableFooter({
    super.key,
    required this.page,
    required this.pageCount,
    required this.pageSize,
    required this.total,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final muted = (theme.textTheme.bodySmall?.color ?? (isDark ? Colors.white : Colors.black)).withValues(alpha: 0.72);

    final start = total == 0 ? 0 : ((page - 1) * pageSize) + 1;
    final end = min(page * pageSize, total);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Text(
            total == 0 ? 'No rows' : 'Showing $start–$end of $total',
            style: theme.textTheme.bodySmall?.copyWith(color: muted, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Prev',
            onPressed: onPrev,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Text(
            'Page $page / $pageCount',
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          IconButton(
            tooltip: 'Next',
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}
