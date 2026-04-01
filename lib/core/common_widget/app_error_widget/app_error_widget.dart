/// ERP System - Error Widget
///
/// Reusable error state widget with retry action.
library;

import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';

class AppErrorWidget extends StatelessWidget {
  final String? message;
  final String? actionText;
  final VoidCallback? onRetry;
  final IconData? icon;

  const AppErrorWidget({
    super.key,
    this.message,
    this.actionText,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline_rounded,
              size: 64,
              color: AppColors.error.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'حدث خطأ غير متوقع',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionText ?? 'إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Network error variant
  factory AppErrorWidget.network({VoidCallback? onRetry}) {
    return AppErrorWidget(
      message: 'تأكد من اتصالك بالإنترنت وحاول مرة أخرى',
      icon: Icons.wifi_off_rounded,
      onRetry: onRetry,
    );
  }

  /// Server error variant
  factory AppErrorWidget.server({VoidCallback? onRetry}) {
    return AppErrorWidget(
      message: 'السيرفر لا يستجيب، حاول مرة أخرى لاحقاً',
      icon: Icons.cloud_off_rounded,
      onRetry: onRetry,
    );
  }
}
