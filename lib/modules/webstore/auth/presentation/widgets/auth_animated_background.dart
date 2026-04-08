import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';

class AuthAnimatedBackground extends StatefulWidget {
  final Widget child;

  const AuthAnimatedBackground({super.key, required this.child});

  @override
  State<AuthAnimatedBackground> createState() => _AuthAnimatedBackgroundState();
}

class _AuthAnimatedBackgroundState extends State<AuthAnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Gradient base
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? const [
                        Color(0xFF07121F),
                        Color(0xFF0B1B2E),
                        Color(0xFF07121F),
                      ]
                    : const [
                        Color(0xFFF6F8FF),
                        Color(0xFFFFFFFF),
                        Color(0xFFF4F7FF),
                      ],
              ),
            ),
          ),
        ),

        // Floating circles (subtle)
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: _FloatingCirclesPainter(
                  t: _controller.value,
                  seed: 17,
                  isDark: isDark,
                ),
              );
            },
          ),
        ),

        // Soft blur overlay for depth
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),

        // Content
        SafeArea(child: widget.child),
      ],
    );
  }
}

class _FloatingCirclesPainter extends CustomPainter {
  final double t;
  final int seed;
  final bool isDark;

  _FloatingCirclesPainter({
    required this.t,
    required this.seed,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(seed);
    final base = isDark ? Colors.white : AppColors.primaryBlue;
    final accent = AppColors.primaryOrange;

    for (int i = 0; i < 10; i++) {
      final dx = rnd.nextDouble();
      final dy = rnd.nextDouble();
      final r = lerpDouble(26, 110, rnd.nextDouble())!;

      final speed = lerpDouble(0.6, 1.8, rnd.nextDouble())!;
      final phase = rnd.nextDouble() * pi * 2;

      final x = (dx * size.width) + sin((t * pi * 2 * speed) + phase) * 18;
      final y = (dy * size.height) + cos((t * pi * 2 * speed) + phase) * 22;

      final color = Color.lerp(base, accent, rnd.nextDouble())!
          .withValues(alpha: isDark ? 0.08 : 0.10);

      final paint = Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FloatingCirclesPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.isDark != isDark;
  }
}

