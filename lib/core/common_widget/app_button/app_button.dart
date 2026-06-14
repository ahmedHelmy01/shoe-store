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
  final Color? backgroundColor;

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
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? 54;
    final bool isDisabled = onPressed == null || isLoading;
    
    if (isGradient) {
      return Opacity(
        opacity: isDisabled ? 0.6 : 1.0,
        child: Container(
          width: width ?? double.infinity,
          height: buttonHeight,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            boxShadow: isDisabled ? null : [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              padding: padding ?? EdgeInsets.zero,
            ),
            child: _buildButtonChild(),
          ),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: buttonHeight,
      child: _buildButton(isDisabled),
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

  Widget _buildButton(bool isDisabled) {
    final style = ElevatedButton.styleFrom(
      padding: padding ?? EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      disabledBackgroundColor: Colors.grey.shade300,
      disabledForegroundColor: Colors.grey.shade500,
    );

    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: style.copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) return Colors.grey.shade300;
              return backgroundColor ?? AppColors.primary;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) return Colors.grey.shade500;
              return Colors.white;
            }),
          ),
          child: _buildButtonChild(),
        );
      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: style.copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) return Colors.grey.shade300;
              return backgroundColor ?? AppColors.secondary;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) return Colors.grey.shade500;
              return Colors.white;
            }),
          ),
          child: _buildButtonChild(),
        );
      case ButtonType.outline:
        return OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: isDisabled ? Colors.grey.shade300 : AppColors.primary,
            ),
            foregroundColor: isDisabled ? Colors.grey.shade400 : AppColors.primary,
            padding: padding ?? EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          child: _buildButtonChild(),
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: isDisabled ? Colors.grey.shade400 : AppColors.primary,
            padding: padding ?? EdgeInsets.zero,
          ),
          child: _buildButtonChild(),
        );
    }
  }
}
