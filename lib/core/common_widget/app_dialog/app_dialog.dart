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

    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius * 1.5),
      ),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius * 1.5),
          gradient: LinearGradient(
            colors: [
              (isDark ? const Color(0xFF17263F) : Colors.white),
              (isDark ? const Color(0xFF101B30) : const Color(0xFFFFFBF8)),
            ],
          ),
          border: Border.all(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryOrange.withValues(alpha: 0.18),
                border: Border.all(color: AppColors.primaryOrange.withValues(alpha: 0.35)),
              ),
              child: const Icon(Icons.warning_amber_rounded, size: 20, color: AppColors.primaryOrange),
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
      ),
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius * 1.5),
          gradient: LinearGradient(
            colors: [
              (isDark ? const Color(0xFF17263F) : Colors.white),
              (isDark ? const Color(0xFF101B30) : const Color(0xFFFFFBF8)),
            ],
          ),
          border: Border(
            left: BorderSide(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
            right: BorderSide(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
            bottom: BorderSide(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
          child: Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.8),
              height: 1.45,
            ),
          ),
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius * 1.5),
            gradient: LinearGradient(
              colors: [
                (isDark ? const Color(0xFF17263F) : Colors.white),
                (isDark ? const Color(0xFF101B30) : const Color(0xFFFFFBF8)),
              ],
            ),
            border: Border(
              left: BorderSide(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
              right: BorderSide(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
              bottom: BorderSide(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (cancelText != null)
                TextButton(
                  onPressed: onCancel ?? () => Navigator.pop(context),
                  child: Text(
                    cancelText!,
                    style: TextStyle(
                      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.72),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (confirmText != null) ...[
                const SizedBox(width: 8),
                AppButton(
                  onPressed: onConfirm ?? () => Navigator.pop(context),
                  type: ButtonType.primary,
                  width: 108,
                  child: Text(
                    confirmText!,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  static void show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }
}
