import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  final bool centerTitle;
  final bool showBackButton;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onPressBack;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CommonAppBar({
    super.key,
    this.title,
    this.titleText,
    this.centerTitle = true,
    this.showBackButton = true,
    this.leading,
    this.trailing,
    this.actions,
    this.bottom,
    this.onPressBack,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;
    final resolvedForeground = foregroundColor ??
        appBarTheme.foregroundColor ??
        theme.colorScheme.onSurface;
    final mergedTitleStyle = appBarTheme.titleTextStyle?.copyWith(
          color: resolvedForeground,
        ) ??
        theme.textTheme.titleLarge?.copyWith(color: resolvedForeground);

    return AppBar(
      backgroundColor: backgroundColor ??
          appBarTheme.backgroundColor ??
          theme.colorScheme.surface,
      foregroundColor: foregroundColor ?? appBarTheme.foregroundColor,
      titleTextStyle: mergedTitleStyle,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      title: title ??
          (titleText != null
              ? Text(titleText!, style: mergedTitleStyle)
              : null),
      leading:
          leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onPressBack ?? () => Navigator.of(context).pop(),
                )
              : null),
      actions: actions ?? (trailing != null ? [trailing!] : null),
      bottom: bottom,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: appBarTheme.systemOverlayStyle,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
