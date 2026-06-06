import 'dart:ui';
import 'package:flutter/material.dart';

class AdminDetailsPanel extends StatelessWidget {
  final String title;
  final String idText;
  final IconData headerIcon;
  final List<MapEntry<String, String>> entries;

  const AdminDetailsPanel({
    super.key,
    required this.title,
    required this.idText,
    required this.entries,
    this.headerIcon = Icons.info_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SelectionArea(
      child: Stack(
      children: [
        Positioned(
          left: -50,
          top: -30,
          child: _GlowCircle(
            size: 140,
            color: Colors.orange.withValues(alpha: isDark ? 0.35 : 0.22),
          ),
        ),
        Positioned(
          right: -40,
          bottom: -20,
          child: _GlowCircle(
            size: 120,
            color: Colors.blue.withValues(alpha: isDark ? 0.28 : 0.18),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
                border: Border.all(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.withValues(alpha: isDark ? 0.24 : 0.14),
                          Colors.deepOrange.withValues(alpha: isDark ? 0.14 : 0.08),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Icon(headerIcon, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          idText,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  for (final entry in entries)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                            (isDark ? Colors.white : Colors.black).withValues(alpha: 0.02),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isDark ? Colors.black : Colors.grey).withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              entry.key,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange.withValues(alpha: 0.85),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 4,
                            child: Text(
                              entry.value,
                              textAlign: TextAlign.end,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withValues(alpha: 0.02),
          ],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: const SizedBox.expand(),
      ),
    );
  }
}
