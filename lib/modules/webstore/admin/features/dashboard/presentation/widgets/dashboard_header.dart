import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/constants/app_constants.dart';

class DashboardHeader extends StatelessWidget {
  final String greeting;
  final bool isLoading;

  const DashboardHeader({
    super.key,
    required this.greeting,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppAnimation.fadeInDown(
      child: Row(
        children: [
          Expanded(
            child: Text(
              greeting,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: AppColors.textColor,
                letterSpacing: -0.8,
              ),
            ),
          ),
          if (isLoading)
            const CircularProgressIndicator(strokeWidth: 3),
        ],
      ),
    );
  }
}

