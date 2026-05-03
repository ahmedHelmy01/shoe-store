import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/core/admin_routes.dart';
import 'widgets/admin_sidebar_header.dart';
import 'widgets/admin_sidebar_item.dart';
import 'widgets/admin_sidebar_group.dart';

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
      _expandedGroup = _groupOf(widget.selected);
    }
    if (!oldWidget.collapsed && widget.collapsed) {
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
            AdminSidebarHeader(collapsed: widget.collapsed),
            const SizedBox(height: 10),
            Divider(height: 1, thickness: 1, color: borderColor),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                children: [
                  for (final node in AdminRoutes.all) ...[
                    if (node.isGroup)
                      AdminSidebarGroup(
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
                      AdminSidebarItem(
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
