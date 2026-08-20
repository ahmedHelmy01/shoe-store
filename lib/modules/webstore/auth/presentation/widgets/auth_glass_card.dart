import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/utils/asset_manager.dart';

class AuthGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool showBrandMark;

  const AuthGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    this.showBrandMark = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: isDark 
                    ? Colors.white.withValues(alpha: 0.05) 
                    : Colors.white.withValues(alpha: 0.9),
                border: Border.all(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
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
                        height: 60,
                        padding: const EdgeInsets.all(8),
                        child: AppImage(
                          imagePath: AssetManager.appIcons,
                          fit: BoxFit.contain,
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
        ),
      ),
    );
  }
}
