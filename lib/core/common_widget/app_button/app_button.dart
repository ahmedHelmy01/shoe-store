import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';

enum ButtonType { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonType type;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final bool isGradient;

  const AppButton({
    super.key,
    this.onPressed,
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
    final buttonHeight = height ?? 54;
    
    if (isGradient) {
      return Container(
        width: width ?? double.infinity,
        height: buttonHeight,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
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
            // Set padding to zero to allow Center to manage the space perfectly
            padding: padding ?? EdgeInsets.zero,
          ),
          child: _buildButtonChild(),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: buttonHeight,
      child: _buildButton(),
    );
  }

  Widget _buildButtonChild() {
    return Center(
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : DefaultTextStyle.merge(
              style: const TextStyle(height: 1.1), // Better line height for Arabic
              child: child,
            ),
    );
  }

  Widget _buildButton() {
    final style = ElevatedButton.styleFrom(
      padding: padding ?? EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
    );

    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: style.copyWith(
            backgroundColor: WidgetStateProperty.all(AppColors.primary),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
          child: _buildButtonChild(),
        );
      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: style.copyWith(
            backgroundColor: WidgetStateProperty.all(AppColors.secondary),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
          child: _buildButtonChild(),
        );
      case ButtonType.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary),
            foregroundColor: AppColors.primary,
            padding: padding ?? EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          child: _buildButtonChild(),
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: padding ?? EdgeInsets.zero,
          ),
          child: _buildButtonChild(),
        );
    }
  }
}
