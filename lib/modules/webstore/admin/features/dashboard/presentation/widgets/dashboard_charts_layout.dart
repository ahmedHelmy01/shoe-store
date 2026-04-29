import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';

class DashboardChartsLayout extends StatelessWidget {
  final List<Widget> charts;

  const DashboardChartsLayout({
    super.key,
    required this.charts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Performance Insights', 
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.hintColor),
        ),
        const SizedBox(height: 16),
        AppAnimation.fadeInUp(
          delay: const Duration(milliseconds: 300),
          child: LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 980;
              if (!wide) {
                return Column(
                  children: charts
                      .map((w) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: SizedBox(height: 280, child: w),
                          ))
                      .toList(),
                );
              }

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(flex: 2, child: SizedBox(height: 300, child: charts[0])),
                      const SizedBox(width: 16),
                      Expanded(flex: 1, child: SizedBox(height: 300, child: charts[1])),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(height: 280, child: charts[2]),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
