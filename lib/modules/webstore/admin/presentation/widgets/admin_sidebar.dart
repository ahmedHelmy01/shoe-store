import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/utils/asset_manager.dart';
import 'package:erp/modules/webstore/admin/presentation/admin_routes.dart';

class AdminSidebar extends StatefulWidget {
  final AdminRouteId selected;
  final ValueChanged<AdminRouteId> onSelect;
  final bool collapsed;

  const AdminSidebar({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.collapsed,
  });

  @override
  State<AdminSidebar> createState() => _AdminSidebarState();
}

class _AdminSidebarState extends State<AdminSidebar> {
  AdminRouteId? _expandedGroup;

  @override
  void initState() {
    super.initState();
    _expandedGroup = _groupOf(widget.selected);
  }

  @override
  void didUpdateWidget(covariant AdminSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      // Big-admin behavior: keep only the active group expanded.
      _expandedGroup = _groupOf(widget.selected);
    }
    if (!oldWidget.collapsed && widget.collapsed) {
      // In collapsed mode we hide groups by default.
      _expandedGroup = null;
    }
  }

  AdminRouteId? _groupOf(AdminRouteId selected) {
    for (final node in AdminRoutes.all) {
      if (!node.isGroup) continue;
      if (node.children.any((c) => c.id == selected)) return node.id;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF0B1524) : const Color(0xFFF7F8FC);
    final borderColor = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      width: widget.collapsed ? 86 : 280,
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          right: BorderSide(color: borderColor),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _BrandHeader(collapsed: widget.collapsed),
            const SizedBox(height: 10),
            Divider(height: 1, thickness: 1, color: borderColor),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                children: [
                  for (final node in AdminRoutes.all) ...[
                    if (node.isGroup)
                      _NavGroup(
                        collapsed: widget.collapsed,
                        node: node,
                        selected: widget.selected,
                        onSelect: widget.onSelect,
                        expanded: !widget.collapsed && _expandedGroup == node.id,
                        onToggleExpanded: () {
                          if (widget.collapsed) return;
                          setState(() {
                            _expandedGroup = (_expandedGroup == node.id) ? null : node.id;
                          });
                        },
                      )
                    else
                      _NavItem(
                        collapsed: widget.collapsed,
                        node: node,
                        selected: widget.selected == node.id,
                        onTap: () => widget.onSelect(node.id),
                      ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  final bool collapsed;
  const _BrandHeader({required this.collapsed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = theme.textTheme.titleMedium?.color ?? (isDark ? Colors.white : Colors.black);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.orangeGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Image.asset(AssetManager.splashTarshouby, fit: BoxFit.contain),
          ),
          if (!collapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tarshouby Admin',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'WebStore Control Panel',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: titleColor.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final AdminNavNode node;
  final bool selected;
  final bool collapsed;
  final VoidCallback onTap;

  const _NavItem({
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
              // Safety for very narrow constraints (e.g. nested children with RTL):
              // fall back to icon-only to avoid RenderFlex overflows.
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

class _NavGroup extends StatefulWidget {
  final AdminNavNode node;
  final AdminRouteId selected;
  final ValueChanged<AdminRouteId> onSelect;
  final bool collapsed;
  final bool expanded;
  final VoidCallback onToggleExpanded;

  const _NavGroup({
    required this.node,
    required this.selected,
    required this.onSelect,
    required this.collapsed,
    required this.expanded,
    required this.onToggleExpanded,
  });

  @override
  State<_NavGroup> createState() => _NavGroupState();
}

class _NavGroupState extends State<_NavGroup> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final hasSelectedChild = widget.node.children.any((c) => c.id == widget.selected);

    if (widget.collapsed) {
      // In collapsed mode, show a popup menu for children.
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
            child: Icon(widget.node.icon, color: theme.iconTheme.color),
          ),
        ),
      );

      return Tooltip(message: widget.node.title, child: tile);
    }

    final fg = hasSelectedChild
        ? (isDark ? Colors.white : const Color(0xFF141414))
        : (theme.textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black));

    final header = InkWell(
      onTap: widget.onToggleExpanded,
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
              // Safety for unexpectedly narrow constraints (RTL + nested layouts).
              if (c.maxWidth < 90) {
                return Center(
                  child: Icon(
                    widget.node.icon,
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
                  Icon(widget.node.icon, size: 22, color: fg),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.node.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: fg,
                        fontWeight: hasSelectedChild ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: widget.expanded ? 0.5 : 0.0,
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
            // Indent children only (no group container box)
            padding: const EdgeInsetsDirectional.only(start: 14, top: 8),
            child: Column(
              children: [
                for (final c in widget.node.children) ...[
                  _NavItem(
                    collapsed: false,
                    node: c,
                    selected: widget.selected == c.id,
                    onTap: () => widget.onSelect(c.id),
                  ),
                  const SizedBox(height: 6),
                ],
              ],
            ),
          ),
          crossFadeState: widget.expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
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
        for (final c in widget.node.children)
          PopupMenuItem<AdminRouteId>(
            value: c.id,
            child: Row(
              children: [
                Icon(c.icon, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(c.title)),
              ],
            ),
          ),
      ],
    );

    if (picked != null) widget.onSelect(picked);
  }
}
