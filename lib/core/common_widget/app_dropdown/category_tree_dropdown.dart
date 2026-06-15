import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';

/// A flat item that represents one row in the category tree dropdown.
class CategoryTreeItem {
  final int? id;
  final String name;
  final bool isChild;

  const CategoryTreeItem({
    required this.id,
    required this.name,
    this.isChild = false,
  });
}

/// A dropdown that displays categories in a tree hierarchy.
///
/// Parent categories are displayed with bold styling, and child (sub) categories
/// are indented with a distinct accent color for visual distinction.
class CategoryTreeDropdown extends StatefulWidget {
  final String? label;
  final String? hint;
  final int? value;
  final List<CategoryTreeItem> items;
  final ValueChanged<int?>? onChanged;
  final bool enabled;

  const CategoryTreeDropdown({
    super.key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    this.onChanged,
    this.enabled = true,
  });

  /// Helper to flatten a tree of categories (with children) into [CategoryTreeItem] list.
  ///
  /// Expects a list of maps each containing `id`, `name`/`name_ar`, and optionally `children`.
  static List<CategoryTreeItem> flattenTree(List<dynamic> categories) {
    final result = <CategoryTreeItem>[];
    for (final cat in categories) {
      final map = cat as Map<String, dynamic>;
      final id = map['id'] as int?;
      final name = (map['name'] ?? map['name_ar'] ?? map['name_en'] ?? 'بدون اسم').toString();
      result.add(CategoryTreeItem(id: id, name: name, isChild: false));

      final children = map['children'] as List?;
      if (children != null) {
        for (final child in children) {
          final childMap = child as Map<String, dynamic>;
          final childId = childMap['id'] as int?;
          final childName = (childMap['name'] ?? childMap['name_ar'] ?? childMap['name_en'] ?? 'بدون اسم').toString();
          result.add(CategoryTreeItem(id: childId, name: childName, isChild: true));
        }
      }
    }
    return result;
  }

  @override
  State<CategoryTreeDropdown> createState() => _CategoryTreeDropdownState();
}

class _CategoryTreeDropdownState extends State<CategoryTreeDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  final GlobalKey _fieldKey = GlobalKey();

  String? get _selectedName {
    if (widget.value == null) return null;
    final match = widget.items.where((e) => e.id == widget.value);
    return match.isNotEmpty ? match.first.name : null;
  }

  void _toggleDropdown() {
    if (!widget.enabled) return;
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    final renderBox = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _DropdownOverlay(
        link: _layerLink,
        fieldWidth: size.width,
        items: widget.items,
        selectedValue: widget.value,
        onSelect: (id) {
          widget.onChanged?.call(id);
          _closeDropdown();
        },
        onDismiss: _closeDropdown,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fill = isDark ? theme.cardColor : AppColors.surface;
    const br = AppConstants.borderRadius;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null && widget.label!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8, right: 4),
            child: Text(
              widget.label!,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            key: _fieldKey,
            onTap: _toggleDropdown,
            child: Container(
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(br),
                border: Border.all(
                  color: _isOpen
                      ? AppColors.primary
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.transparent),
                  width: _isOpen ? 1.5 : 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedName ?? widget.hint ?? '',
                      style: TextStyle(
                        color: _selectedName != null
                            ? theme.textTheme.bodyLarge?.color
                            : AppColors.textHint,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondary,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The overlay popup that shows the tree items.
class _DropdownOverlay extends StatelessWidget {
  final LayerLink link;
  final double fieldWidth;
  final List<CategoryTreeItem> items;
  final int? selectedValue;
  final ValueChanged<int?> onSelect;
  final VoidCallback onDismiss;

  const _DropdownOverlay({
    required this.link,
    required this.fieldWidth,
    required this.items,
    this.selectedValue,
    required this.onSelect,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Dismiss layer
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.opaque,
            child: const SizedBox.expand(),
          ),
        ),
        // Dropdown menu
        CompositedTransformFollower(
          link: link,
          showWhenUnlinked: false,
          offset: const Offset(0, 52),
          child: Material(
            elevation: 8,
            shadowColor: Colors.black26,
            borderRadius: BorderRadius.circular(12),
            color: isDark ? theme.cardColor : Colors.white,
            child: Container(
              width: fieldWidth,
              constraints: const BoxConstraints(maxHeight: 320),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.grey.withValues(alpha: 0.15),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = item.id == selectedValue;

                    return _TreeItemTile(
                      item: item,
                      isSelected: isSelected,
                      isDark: isDark,
                      onTap: () => onSelect(item.id),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A single tile in the dropdown tree.
class _TreeItemTile extends StatelessWidget {
  final CategoryTreeItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _TreeItemTile({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Parent: bold, primary text color
    // Child: indented, accent color with a subtle left border
    final isChild = item.isChild;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected
            ? (isDark
                ? AppColors.primary.withValues(alpha: 0.15)
                : AppColors.primary.withValues(alpha: 0.08))
            : null,
        padding: EdgeInsets.only(
          left: isChild ? 32 : 16,
          right: 16,
          top: isChild ? 10 : 12,
          bottom: isChild ? 10 : 12,
        ),
        child: Row(
          children: [
            if (isChild)
              Container(
                width: 3,
                height: 18,
                margin: const EdgeInsets.only(right: 10,left: 10),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            if (!isChild)
              Icon(
                Icons.folder_rounded,
                size: 18,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            if (!isChild) const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  fontSize: isChild ? 14 : 15,
                  fontWeight: isChild ? FontWeight.w400 : FontWeight.w600,
                  color: isChild
                      ? (isSelected ? AppColors.secondary : AppColors.secondary.withValues(alpha: 0.85))
                      : (isSelected ? AppColors.primary : (isDark ? Colors.white : AppColors.textMain)),
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_rounded,
                size: 18,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
