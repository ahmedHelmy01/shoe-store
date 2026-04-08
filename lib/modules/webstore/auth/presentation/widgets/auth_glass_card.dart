import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:erp/core/utils/asset_manager.dart';

class AuthGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool showBrandMark;

  const AuthGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.showBrandMark = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.06 : 0.03),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.14 : 0.08),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showBrandMark) ...[
                Center(
                  child: Container(
                    width: 92,
                    height: 92,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.06 : 0.03),
                      border: Border.all(
                        color: (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.16 : 0.08),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.10),
                          blurRadius: 30,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        AssetManager.splashTarshouby,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}

