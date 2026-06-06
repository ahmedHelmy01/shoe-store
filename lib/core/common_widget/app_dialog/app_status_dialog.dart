import 'package:erp/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';

enum AppDialogStatus { success, error }

class AppStatusDialog extends StatelessWidget {
  static bool _isShowing = false;
  static String?
  lastApiError; // Global variable to hold last API error for generic messages

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
    required this.actionText,
    this.onActionPressed,
  });

  static Future<void> show(
    BuildContext context, {
    required AppDialogStatus status,
    required String title,
    required String message,
    String? actionText,
    VoidCallback? onActionPressed,
  }) {
    if (_isShowing) return Future.value();
    _isShowing = true;

    final dialogMessage =
        (status == AppDialogStatus.error &&
            lastApiError != null &&
            lastApiError!.isNotEmpty &&
            !message.contains(lastApiError!))
        ? '$message\n\n$lastApiError'
        : message;

    // Clear the error so it doesn't leak
    lastApiError = null;

    return showGeneralDialog<void>(
      context: context,
      barrierLabel: 'StatusDialog',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, _, _) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            _isShowing = false;
          },
          child: SafeArea(
            child: Center(
              child: AppStatusDialog(
                status: status,
                title: title,
                message: dialogMessage,
                actionText:
                    actionText ?? LocaleKeys.common.ok.tr(context: context),
                onActionPressed: onActionPressed,
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: curved, child: child),
        );
      },
    ).then((_) => _isShowing = false);
  }

  static Future<void> showSuccess(
    BuildContext context, {
    String? title,
    required String message,
    String? actionText,
    VoidCallback? onActionPressed,
  }) {
    return show(
      context,
      status: AppDialogStatus.success,
      title: title ?? LocaleKeys.common.sent_successfully.tr(context: context),
      message: message,
      actionText: actionText ?? LocaleKeys.common.ok.tr(context: context),
      onActionPressed: onActionPressed,
    );
  }

  static Future<void> showError(
    BuildContext context, {
    String? title,
    required String message,
    String? actionText,
    VoidCallback? onActionPressed,
  }) {
    return show(
      context,
      status: AppDialogStatus.error,
      title: title ?? LocaleKeys.common.error.tr(context: context),
      message: message,
      actionText: actionText ?? LocaleKeys.common.ok.tr(context: context),
      onActionPressed: onActionPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSuccess = status == AppDialogStatus.success;
    final statusColor = isSuccess ? AppColors.success : AppColors.error;
    final statusIcon = isSuccess
        ? Icons.check_circle_rounded
        : Icons.error_rounded;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: SelectionArea(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F1D35) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.12,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? statusColor : Colors.black).withValues(
                  alpha: isDark ? 0.22 : 0.08,
                ),
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
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.75),
                      width: 2,
                    ),
                  ),
                  child: Icon(statusIcon, size: 40, color: statusColor),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: (isDark ? Colors.white : Colors.black87).withValues(
                    alpha: 0.85,
                  ),
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
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Always close dialog first
                    onActionPressed
                        ?.call(); // Then execute callback if provided
                  },
                  child: Text(
                    actionText,
                    style: const TextStyle(fontWeight: FontWeight.w600),
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
