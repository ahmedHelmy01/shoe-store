import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/admin/core/admin_routes.dart';

class AdminSidebarItem extends StatelessWidget {
  final AdminNavNode node;
  final bool selected;
  final bool collapsed;
  final VoidCallback onTap;

  const AdminSidebarItem({
    super.key,
    required this.node,
    required this.selected,
    required this.collapsed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (collapsed) {
      final tile = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: selected ? AppColors.orangeGradient : null,
            color: selected ? null : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
            border: Border.all(
              color: selected ? Colors.transparent : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
            ),
          ),
          child: Center(
            child: Icon(
              node.icon,
              size: 22,
              color: selected ? (isDark ? Colors.white : const Color(0xFF141414)) : theme.iconTheme.color,
            ),
          ),
        ),
      );

      return Tooltip(message: node.title, child: tile);
    }

    final fg = selected
        ? (isDark ? Colors.white : const Color(0xFF141414))
        : (theme.textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black));
    final bg = selected
        ? AppColors.orangeGradient
        : LinearGradient(
            colors: [
              (isDark ? Colors.white : Colors.black).withValues(alpha: 0.00),
              (isDark ? Colors.white : Colors.black).withValues(alpha: 0.00),
            ],
          );

    final tile = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: bg,
          color: selected
              ? null
              : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth < 64) {
                return Center(child: Icon(node.icon, size: 22, color: fg));
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    width: 4,
                    height: 22,
                    margin: const EdgeInsetsDirectional.only(end: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: selected ? (isDark ? Colors.white : const Color(0xFF141414)) : Colors.transparent,
                    ),
                  ),
                  Icon(node.icon, size: 22, color: fg),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      node.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: fg,
                        fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    return tile;
  }
}
