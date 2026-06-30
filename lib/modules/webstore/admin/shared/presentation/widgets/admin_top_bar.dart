import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class AdminTopBar extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentLocale = context.locale;
    final isAr = currentLocale.languageCode == 'ar';

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
              AdminLocalizations.translate(context, title),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(width: 10),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: theme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              final nextCode = isAr ? 'en' : 'ar';
              await ref.read(sessionManagerProvider).setLocale(nextCode);
              if (context.mounted) {
                await context.setLocale(Locale(nextCode));
              }
            },
            icon: const Icon(Icons.translate_rounded, size: 16),
            label: Text(
              isAr ? 'English' : 'العربية',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
