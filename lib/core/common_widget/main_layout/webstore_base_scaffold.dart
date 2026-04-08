import 'package:erp/core/config/app_config_manager.dart';
import 'package:erp/core/common_widget/network_listener.dart';
import 'package:erp/core/common_widget/cart_listener.dart';
import 'package:flutter/material.dart';
import '../app_bar/common_app_bar.dart';

class WebStoreBaseScaffold extends StatelessWidget {
  final Widget body;
  final Widget? title;
  final String? titleText;
  final bool showBack;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Widget? drawer;
  final VoidCallback? onPressBack;
  final PreferredSizeWidget? appBarBottom;
  final bool centerTitle;
  final Color? backgroundColor;
  final bool showAppBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const WebStoreBaseScaffold({
    super.key,
    required this.body,
    this.title,
    this.titleText,
    this.showBack = false,
    this.leftIcon,
    this.rightIcon,
    this.scaffoldKey,
    this.drawer,
    this.onPressBack,
    this.appBarBottom,
    this.centerTitle = true,
    this.backgroundColor,
    this.showAppBar = true,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scaffoldBg = backgroundColor ?? theme.scaffoldBackgroundColor;

    final scaffoldBody = Scaffold(
      key: scaffoldKey,
      drawer: drawer,
      backgroundColor: scaffoldBg,
      extendBodyBehindAppBar: false, // Standardizing to avoid overlap issues
      resizeToAvoidBottomInset: true,
      appBar: showAppBar
          ? CommonAppBar(
              title: title,
              titleText: titleText,
              centerTitle: centerTitle,
              showBackButton: showBack,
              leading: leftIcon,
              trailing: rightIcon,
              bottom: appBarBottom,
              onPressBack: onPressBack,
            )
          : null,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: NetworkListener(
        child: CartListener(
          child: body,
        ),
      ),
    );

    // Keep gradient functionality but make it theme-aware
    final appConfig = AppConfigManager.instance;
    if (appConfig.customSettings.enableGradientBackground &&
        backgroundColor == null &&
        appConfig.customTheme != null) {
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  appConfig.customTheme!.linearGradientHome,
                  isDark ? theme.scaffoldBackgroundColor : Colors.white,
                ],
                stops: const [0.0, 0.5],
              ),
            ),
          ),
          scaffoldBody,
        ],
      );
    }

    return scaffoldBody;
  }
}
