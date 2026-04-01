import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';

enum ButtonType { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final ButtonType type;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final bool isGradient;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.type = ButtonType.primary,
    this.width,
    this.height,
    this.padding,
    this.isLoading = false,
    this.isGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isGradient) {
      return Container(
        width: width ?? double.infinity,
        height: height ?? 54,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            padding: padding,
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : child,
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 54,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: padding,
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : child,
        );
      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            padding: padding,
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : child,
        );
      case ButtonType.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary),
            foregroundColor: AppColors.primary,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: AppColors.primary)
              : child,
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: padding,
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: AppColors.primary)
              : child,
        );
    }
  }
}
