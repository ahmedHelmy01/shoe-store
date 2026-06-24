import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';

/// Shared dropdown styled like [AppTextField] (label + filled field + focus ring).
class AppDropdown<T> extends StatelessWidget {
  final String? label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final bool enabled;
  final double? borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final EdgeInsetsGeometry contentPadding;
  final double? fieldHeight;
  final double? menuMaxHeight;
  final double? menuMaxWidth;
  final double? maxHeight;

  const AppDropdown({
    super.key,
    this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
    this.enabled = true,
    this.borderRadius,
    this.borderColor,
    this.focusedBorderColor,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    this.fieldHeight,
    this.menuMaxHeight,
    this.menuMaxWidth,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fill = isDark ? theme.cardColor : AppColors.surface;
    final br = borderRadius ?? AppConstants.borderRadius;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null && label!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8, right: 4),
            child: Text(
              label!,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(br)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: fieldHeight ?? 0,
              maxHeight: maxHeight ?? double.infinity,
            ),
            child: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: fill,
                contentPadding: contentPadding,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(br),
                  borderSide: borderColor != null
                      ? BorderSide(color: borderColor!)
                      : BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(br),
                  borderSide: borderColor != null
                      ? BorderSide(color: borderColor!)
                      : (isDark
                            ? BorderSide(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 1,
                              )
                            : BorderSide.none),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(br),
                  borderSide: BorderSide(
                    color: focusedBorderColor ?? AppColors.primary,
                    width: 1.5,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(br),
                  borderSide: BorderSide(
                    color: (isDark ? Colors.white : Colors.black).withValues(
                      alpha: 0.08,
                    ),
                  ),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  isExpanded: true,
                  value: value,
                  hint: hint != null
                      ? Text(
                          hint!,
                          style: const TextStyle(color: AppColors.textHint),
                        )
                      : null,
                  items: items,
                  onChanged: enabled ? onChanged : null,
                  style: theme.textTheme.bodyLarge,
                  borderRadius: BorderRadius.circular(br),
                  menuMaxHeight: menuMaxHeight,
                  menuWidth: menuMaxWidth,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

