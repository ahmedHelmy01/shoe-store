import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final bool centerTitle;
  final bool showBackButton;
  final Widget? leading;
  final Widget? trailing;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onPressBack;

  const CommonAppBar({
    super.key,
    this.title,
    this.centerTitle = true,
    this.showBackButton = true,
    this.leading,
    this.trailing,
    this.bottom,
    this.onPressBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onPressBack ?? () => Navigator.of(context).pop(),
                )
              : null),
      actions: trailing != null ? [trailing!] : null,
      bottom: bottom,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
