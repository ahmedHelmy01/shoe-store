import 'package:flutter/material.dart';

class AnimatedBackground extends StatelessWidget {
  final int currentPage;
  final List<List<Color>> gradients;

  const AnimatedBackground({
    super.key,
    required this.currentPage,
    required this.gradients,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.5,
          colors: [
            gradients[currentPage % gradients.length][1].withValues(alpha: 0.5),
            gradients[currentPage % gradients.length][0],
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomLeft,
            radius: 1.2,
            colors: [
              gradients[currentPage % gradients.length][0].withValues(alpha: 0.3),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
