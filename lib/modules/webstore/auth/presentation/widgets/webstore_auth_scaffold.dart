import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/modules/webstore/auth/presentation/widgets/auth_animated_background.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';

class WebStoreAuthScaffold extends StatelessWidget {
  final Widget child;
  final bool showBack;
  final EdgeInsetsGeometry padding;
  final bool center;
  final bool showAppBar;
  final String? titleText;
  final VoidCallback? onPressBack;
  final bool useAnimatedBackground;

  const WebStoreAuthScaffold({
    super.key,
    required this.child,
    this.showBack = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0),
    this.center = true,
    this.showAppBar = true,
    this.titleText,
    this.onPressBack,
    this.useAnimatedBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = center
        ? Center(
            child: SingleChildScrollView(
              padding: padding,
              child: AppAnimation.fadeZoomIn(
                duration: const Duration(milliseconds: 650),
                child: child,
              ),
            ),
          )
        : SingleChildScrollView(
            padding: padding,
            child: AppAnimation.fadeInUp(
              duration: const Duration(milliseconds: 650),
              child: child,
            ),
          );

    final body = useAnimatedBackground ? AuthAnimatedBackground(child: content) : content;

    return WebStoreBaseScaffold(
      showBack: showBack,
      showAppBar: showAppBar,
      titleText: titleText,
      onPressBack: onPressBack ?? () => Navigator.of(context).maybePop(),
      body: body,
    );
  }
}

