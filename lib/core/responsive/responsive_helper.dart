import 'package:flutter/material.dart';

/// Standard breakpoints for the ERP system.
class AdminBreakpoints {
  static const double mobile = 720;
  static const double tablet = 1024;
  static const double desktop = 1440;
}

class ResponsiveHelper {
  final BuildContext context;
  ResponsiveHelper(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  bool get isMobile => width < AdminBreakpoints.mobile;
  bool get isTablet => width >= AdminBreakpoints.mobile && width < AdminBreakpoints.tablet;
  bool get isDesktop => width >= AdminBreakpoints.tablet;
  
  /// Returns true if the screen is "small" (mobile or narrow tablet).
  bool get isNarrow => width < 980;

  /// Helper for choosing between values based on screen size.
  T value<T>({
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isMobile) return mobile;
    if (isTablet) return tablet ?? mobile;
    return desktop;
  }
}

/// A wrapper widget to build different layouts based on screen size.
class AdaptiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AdminBreakpoints.mobile) return mobile;
        if (constraints.maxWidth < AdminBreakpoints.tablet) return tablet ?? mobile;
        return desktop;
      },
    );
  }
}
