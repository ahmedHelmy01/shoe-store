import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/admin/core/admin_routes.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'admin_sidebar_item.dart';

class AdminSidebarGroup extends StatelessWidget {
  final AdminNavNode node;
  final AdminRouteId selected;
  final ValueChanged<AdminRouteId> onSelect;
  final bool collapsed;
  final bool expanded;
  final VoidCallback onToggleExpanded;

  const AdminSidebarGroup({
    super.key,
    required this.node,
    required this.selected,
    required this.onSelect,
    required this.collapsed,
    required this.expanded,
    required this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final hasSelectedChild = node.children.any((c) => c.id == selected);

    if (collapsed) {
      final tile = InkWell(
        onTap: () => _showChildrenMenu(context),
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: hasSelectedChild
                ? AppColors.primaryOrange.withValues(alpha: 0.14)
                : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
            ),
          ),
          child: Center(
            child: Icon(node.icon, color: theme.iconTheme.color),
          ),
        ),
      );

      return Tooltip(message: AdminLocalizations.translate(context, node.title), child: tile);
    }

    final fg = hasSelectedChild
        ? (isDark ? Colors.white : const Color(0xFF141414))
        : (theme.textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black));

    final header = InkWell(
      onTap: onToggleExpanded,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: hasSelectedChild ? AppColors.orangeGradient : null,
          color: hasSelectedChild ? null : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
          border: Border.all(
            color: hasSelectedChild
                ? Colors.transparent
                : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth < 90) {
                return Center(
                  child: Icon(
                    node.icon,
                    size: 22,
                    color: fg,
                  ),
                );
              }

              return Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    width: 4,
                    height: 22,
                    margin: const EdgeInsetsDirectional.only(end: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: hasSelectedChild ? (isDark ? Colors.white : const Color(0xFF141414)) : Colors.transparent,
                    ),
                  ),
                  Icon(node.icon, size: 22, color: fg),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AdminLocalizations.translate(context, node.title),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: fg,
                        fontWeight: hasSelectedChild ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    child: Icon(Icons.expand_more_rounded, color: fg),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    return Column(
      children: [
        header,
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsetsDirectional.only(start: 14, top: 8),
            child: Column(
              children: [
                for (final c in node.children) ...[
                  AdminSidebarItem(
                    collapsed: false,
                    node: c,
                    selected: selected == c.id,
                    onTap: () => onSelect(c.id),
                  ),
                  const SizedBox(height: 6),
                ],
              ],
            ),
          ),
          crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 180),
          firstCurve: Curves.easeOutCubic,
          secondCurve: Curves.easeOutCubic,
        ),
      ],
    );
  }

  Future<void> _showChildrenMenu(BuildContext context) async {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
    final box = context.findRenderObject() as RenderBox?;
    if (overlay == null || box == null) return;

    final origin = box.localToGlobal(Offset.zero, ancestor: overlay);
    final rect = RelativeRect.fromLTRB(
      origin.dx,
      origin.dy,
      overlay.size.width - origin.dx - box.size.width,
      overlay.size.height - origin.dy - box.size.height,
    );

    final picked = await showMenu<AdminRouteId>(
      context: context,
      position: rect,
      items: [
        for (final c in node.children)
          PopupMenuItem<AdminRouteId>(
            value: c.id,
            child: Row(
              children: [
                Icon(c.icon, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(AdminLocalizations.translate(context, c.title))),
              ],
            ),
          ),
      ],
    );

    if (picked != null) onSelect(picked);
  }
}
