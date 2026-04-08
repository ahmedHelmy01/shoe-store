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
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      title: title ?? (titleText != null ? Text(titleText!) : null),
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
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
