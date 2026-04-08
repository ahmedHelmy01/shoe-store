import 'dart:math';
import 'package:flutter/material.dart';

class FloatingParticles extends StatelessWidget {
  final Animation<double> floatAnimation;

  const FloatingParticles({super.key, required this.floatAnimation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: floatAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _ParticlesPainter(
            progress: floatAnimation.value,
            color: Colors.white.withOpacity(0.08),
          ),
        );
      },
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ParticlesPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final random = Random(42);

    for (int i = 0; i < 20; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 4 + 2;

      final offsetY = sin(progress * pi * 2 + i) * 20;
      final offsetX = cos(progress * pi * 2 + i * 0.5) * 10;

      canvas.drawCircle(
        Offset(baseX + offsetX, baseY + offsetY),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
