import 'package:flutter/material.dart';

enum AnimationType {
  fadeInUp,
  fadeInDown,
  fadeInLeft,
  fadeInRight,
  fadeZoomIn,
}

class AppAnimation extends StatelessWidget {
  final Widget child;
  final AnimationType type;
  final Duration duration;
  final Duration delay;
  final double offset;

  const AppAnimation({
    super.key,
    required this.child,
    this.type = AnimationType.fadeInUp,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.offset = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: duration,
        curve: Curves.easeOutQuart,
        builder: (context, value, child) {
          Widget content = child!;
          
          if (type == AnimationType.fadeZoomIn) {
            content = Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: content,
            );
          }

          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: _getOffset(value),
              child: content,
            ),
          );
        },
        child: child,
      ),
    );
  }

  Offset _getOffset(double value) {
    final double currentOffset = offset * (1 - value);
    switch (type) {
      case AnimationType.fadeInUp:
        return Offset(0, currentOffset);
      case AnimationType.fadeInDown:
        return Offset(0, -currentOffset);
      case AnimationType.fadeInLeft:
        return Offset(-currentOffset, 0);
      case AnimationType.fadeInRight:
        return Offset(currentOffset, 0);
      case AnimationType.fadeZoomIn:
        return Offset.zero;
    }
  }

  /// Shortcut for FadeInUp
  static Widget fadeInUp({
    Key? key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 800),
    Duration delay = Duration.zero,
    double offset = 30.0,
  }) {
    return AppAnimation(
      key: key,
      type: AnimationType.fadeInUp,
      duration: duration,
      delay: delay,
      offset: offset,
      child: child,
    );
  }

  /// Shortcut for FadeInDown
  static Widget fadeInDown({
    required Widget child,
    Duration duration = const Duration(milliseconds: 800),
    Duration delay = Duration.zero,
    double offset = 30.0,
  }) {
    return AppAnimation(
      type: AnimationType.fadeInDown,
      duration: duration,
      delay: delay,
      offset: offset,
      child: child,
    );
  }

  /// Shortcut for FadeInLeft
  static Widget fadeInLeft({
    required Widget child,
    Duration duration = const Duration(milliseconds: 800),
    Duration delay = Duration.zero,
    double offset = 30.0,
  }) {
    return AppAnimation(
      type: AnimationType.fadeInLeft,
      duration: duration,
      delay: delay,
      offset: offset,
      child: child,
    );
  }

  /// Shortcut for FadeInRight
  static Widget fadeInRight({
    required Widget child,
    Duration duration = const Duration(milliseconds: 800),
    Duration delay = Duration.zero,
    double offset = 30.0,
  }) {
    return AppAnimation(
      type: AnimationType.fadeInRight,
      duration: duration,
      delay: delay,
      offset: offset,
      child: child,
    );
  }

  /// Shortcut for FadeZoomIn
  static Widget fadeZoomIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 800),
    Duration delay = Duration.zero,
  }) {
    return AppAnimation(
      type: AnimationType.fadeZoomIn,
      duration: duration,
      delay: delay,
      offset: 0.0,
      child: child,
    );
  }
}
