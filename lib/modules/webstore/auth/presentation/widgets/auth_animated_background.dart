import 'package:flutter/material.dart';

class AuthAnimatedBackground extends StatelessWidget {
  final Widget child;

  const AuthAnimatedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // Simple and light background for better performance
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      body: Stack(
        children: [
          // Subtle background pattern (optional, kept very light)
          if (!isDark)
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withValues(alpha: 0.03),
                ),
              ),
            ),
          
          // Content
          SafeArea(child: child),
        ],
      ),
    );
  }
}
