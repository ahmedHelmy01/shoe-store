import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';

class LoginBackground extends StatefulWidget {
  const LoginBackground({super.key});

  @override
  State<LoginBackground> createState() => _LoginBackgroundState();
}

class _LoginBackgroundState extends State<LoginBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF07121F), Color(0xFF0D1C2E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        
        // Animated Circles
        _FloatingCircle(
          controller: _controller,
          color: AppColors.primaryOrange.withValues(alpha: 0.1),
          size: 400,
          offset: const Offset(-100, -100),
          speed: 1.0,
        ),
        _FloatingCircle(
          controller: _controller,
          color: AppColors.primaryOrange.withValues(alpha: 0.05),
          size: 300,
          offset: const Offset(200, 300),
          speed: -1.2,
        ),
        _FloatingCircle(
          controller: _controller,
          color: Colors.white.withValues(alpha: 0.03),
          size: 500,
          offset: const Offset(-200, 600),
          speed: 0.8,
        ),
      ],
    );
  }
}

class _FloatingCircle extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  final double size;
  final Offset offset;
  final double speed;

  const _FloatingCircle({
    required this.controller,
    required this.color,
    required this.size,
    required this.offset,
    required this.speed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final double t = controller.value * 2 * math.pi;
        final double dx = math.sin(t * speed) * 40;
        final double dy = math.cos(t * speed) * 40;
        
        return Positioned(
          left: offset.dx + dx,
          top: offset.dy + dy,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        );
      },
    );
  }
}
