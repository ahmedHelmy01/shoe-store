import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        duration: duration,
      ),
    );
  }

  /// Show an error snack bar (convenience method)
  static void showError(BuildContext context, String message) {
    show(context, message: message, isError: true);
  }

  /// Show a success snack bar (convenience method)
  static void showSuccess(BuildContext context, String message) {
    show(context, message: message, isError: false);
  }
}

