import 'package:erp/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

enum AppDialogStatus { success, error }

class AppStatusDialog extends StatelessWidget {
  final AppDialogStatus status;
  final String title;
  final String message;
  final String actionText;
  final VoidCallback? onActionPressed;

  const AppStatusDialog({
    super.key,
    required this.status,
    required this.title,
    required this.message,
    this.actionText = 'OK',
    this.onActionPressed,
  });

  static Future<void> show(
    BuildContext context, {
    required AppDialogStatus status,
    required String title,
    required String message,
    String actionText = 'OK',
    VoidCallback? onActionPressed,
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierLabel: 'StatusDialog',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, _, _) {
        return SafeArea(
          child: Center(
            child: AppStatusDialog(
              status: status,
              title: title,
              message: message,
              actionText: actionText,
              onActionPressed: onActionPressed,
            ),
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: curved, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = status == AppDialogStatus.success;
    final statusColor = isSuccess ? AppColors.success : AppColors.error;
    final statusIcon = isSuccess ? Icons.check_circle_rounded : Icons.error_rounded;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1D35),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: statusColor.withValues(alpha: 0.22),
              blurRadius: 34,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.7, end: 1),
              duration: const Duration(milliseconds: 380),
              curve: Curves.elasticOut,
              builder: (_, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor.withValues(alpha: 0.15),
                  border: Border.all(color: statusColor.withValues(alpha: 0.75), width: 2),
                ),
                child: Icon(statusIcon, size: 40, color: statusColor),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 14,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
                onPressed: onActionPressed ?? () => Navigator.of(context).pop(),
                child: Text(
                  actionText,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
