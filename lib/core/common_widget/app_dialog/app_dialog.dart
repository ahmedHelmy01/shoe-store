import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final radius = BorderRadius.circular(AppConstants.borderRadius * 1.8);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 430),
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
        decoration: BoxDecoration(
          borderRadius: radius,
          color: isDark ? const Color(0xFF13233D) : Colors.white,
          border: Border.all(
            color: (isDark ? Colors.white : Colors.black).withValues(
              alpha: 0.08,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (isDark ? Colors.white : Colors.black).withValues(
                      alpha: 0.06,
                    ),
                    border: Border.all(
                      color: (isDark ? Colors.white : Colors.black).withValues(
                        alpha: 0.12,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 22,
                    color: isDark ? Colors.white : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: (isDark ? Colors.white : Colors.black).withValues(
                    alpha: 0.82,
                  ),
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (cancelText != null)
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: onCancel ?? () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: (isDark ? Colors.white : Colors.black)
                                .withValues(alpha: 0.18),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                          ),
                        ),
                        child: Text(
                          cancelText!,
                          style: TextStyle(
                            color: (isDark ? Colors.white : Colors.black)
                                .withValues(alpha: 0.74),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (cancelText != null && confirmText != null)
                  const SizedBox(width: 10),
                if (confirmText != null)
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: AppButton(
                        onPressed: onConfirm ?? () => Navigator.pop(context),
                        type: ButtonType.primary,
                        child: Text(
                          confirmText!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierLabel: 'AppDialog',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, __, ___) => SafeArea(
        child: Center(
          child: AppDialog(
            title: title,
            message: message,
            confirmText: confirmText,
            cancelText: cancelText,
            onConfirm: onConfirm,
            onCancel: onCancel,
          ),
        ),
      ),
      transitionBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
