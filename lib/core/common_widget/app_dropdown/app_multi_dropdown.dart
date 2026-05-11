import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';

/// A multi-select dropdown widget styled like [AppTextField].
class AppMultiDropdown<T> extends StatefulWidget {
  final String? label;
  final List<T> selectedValues;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<List<T>> onChanged;
  final String? hint;
  final bool enabled;
  final double? borderRadius;
  final String Function(T)? itemLabelBuilder;

  const AppMultiDropdown({
    super.key,
    this.label,
    required this.selectedValues,
    required this.items,
    required this.onChanged,
    this.hint,
    this.enabled = true,
    this.borderRadius,
    this.itemLabelBuilder,
  });

  @override
  State<AppMultiDropdown<T>> createState() => _AppMultiDropdownState<T>();
}

class _AppMultiDropdownState<T> extends State<AppMultiDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fill = isDark ? theme.cardColor : AppColors.surface;
    final br = widget.borderRadius ?? AppConstants.borderRadius;

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
        GestureDetector(
          onTap: widget.enabled ? _showMultiSelectDialog : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(br),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: widget.selectedValues.isEmpty
                      ? Text(
                          widget.hint ?? 'Select options',
                          style: const TextStyle(color: AppColors.textHint),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: widget.selectedValues.map((val) {
                            final item = widget.items.cast<DropdownMenuItem<T>?>().firstWhere(
                              (i) => i?.value == val,
                              orElse: () => null,
                            );
                            return Chip(
                              label: item?.child ?? Text(val.toString()),
                              onDeleted: widget.enabled
                                  ? () {
                                      final newList = List<T>.from(widget.selectedValues)..remove(val);
                                      widget.onChanged(newList);
                                    }
                                  : null,
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              labelStyle: const TextStyle(fontSize: 12),
                            );
                          }).toList(),
                        ),
                ),
                const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showMultiSelectDialog() async {
    final List<T>? results = await showDialog<List<T>>(
      context: context,
      builder: (context) => _MultiSelectDialog<T>(
        items: widget.items,
        initialSelectedValues: widget.selectedValues,
      ),
    );

    if (results != null) {
      widget.onChanged(results);
    }
  }
}

class _MultiSelectDialog<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final List<T> initialSelectedValues;

  const _MultiSelectDialog({
    required this.items,
    required this.initialSelectedValues,
  });

  @override
  State<_MultiSelectDialog<T>> createState() => _MultiSelectDialogState<T>();
}

class _MultiSelectDialogState<T> extends State<_MultiSelectDialog<T>> {
  late List<T> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List<T>.from(widget.initialSelectedValues);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? const Color(0xFF1A1F2B) : Colors.white,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Select Options',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: widget.items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final isSelected = _selectedValues.contains(item.value);
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedValues.remove(item.value);
                        } else {
                          _selectedValues.add(item.value as T);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : Colors.grey.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DefaultTextStyle(
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ) ?? const TextStyle(),
                              child: item.child,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding:  EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(_selectedValues),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

