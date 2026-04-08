import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';

class AdminTopBar extends StatelessWidget {
  final String title;
  final VoidCallback onToggleNav;
  final bool isNavCollapsed;
  final bool showHamburger;

  const AdminTopBar({
    super.key,
    required this.title,
    required this.onToggleNav,
    required this.isNavCollapsed,
    required this.showHamburger,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF0B1524) : Colors.white),
        border: Border(
          bottom: BorderSide(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: showHamburger ? 'Menu' : (isNavCollapsed ? 'Expand' : 'Collapse'),
            onPressed: onToggleNav,
            icon: Icon(showHamburger ? Icons.menu_rounded : (isNavCollapsed ? Icons.chevron_right_rounded : Icons.chevron_left_rounded)),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primaryOrange.withValues(alpha: 0.12),
            child: const Icon(Icons.admin_panel_settings_rounded, size: 18, color: AppColors.primaryOrange),
          ),
        ],
      ),
    );
  }
}
