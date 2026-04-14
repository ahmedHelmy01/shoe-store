import 'package:flutter/material.dart';
import 'package:erp/core/utils/asset_manager.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';

/// A premium, illustration-driven state widget for Admin CRUD pages.
/// Handles error, unauthorized, and empty states with a consistent, 
/// professional look across the entire admin module.
class AdminStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AdminStateWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnauthorized = message.toLowerCase().contains('unauth') ||
        message.toLowerCase().contains('401') ||
        message.toLowerCase().contains('403');

    final illustrationPath = isUnauthorized
        ? AssetManager.adminUnauthorized
        : AssetManager.adminError;

    final title = isUnauthorized
        ? 'Access Denied'
        : 'Something Went Wrong';

    final subtitle = isUnauthorized
        ? 'You don\'t have permission to view this page.\nPlease login again or contact your administrator.'
        : message;

    return AppAnimation.fadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Illustration
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320, maxHeight: 320),
                child: Image.asset(
                  illustrationPath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    isUnauthorized ? Icons.lock_outline_rounded : Icons.error_outline_rounded,
                    size: 80,
                    color: AppColors.primaryOrange.withValues(alpha: 0.6),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Title
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Subtitle / Error Message
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.55),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 28),

              // Retry Button
              if (onRetry != null)
                SizedBox(
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: const Text(
                      'Retry',
                      style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.2),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
