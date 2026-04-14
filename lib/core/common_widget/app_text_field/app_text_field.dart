import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/security/security_sanitizer.dart';

class SecurityTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final sanitized = SecuritySanitizer.sanitize(newValue.text);
    if (sanitized == newValue.text) return newValue;
    
    return newValue.copyWith(
      text: sanitized,
      selection: TextSelection.collapsed(offset: sanitized.length),
    );
  }
}

class AppTextField extends StatefulWidget {
  final int? maxLines;
  final String? hint;
  final String? label;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextStyle? style;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final bool obscureText;
  final Color? fillColor;
  final bool useLabelAsHint;
  final Color? shadowColor;
  final EdgeInsetsGeometry? prefixIconPadding;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? hintStyle;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final double? borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;

  const AppTextField({
    super.key,
    this.maxLines = 1,
    this.hint,
    this.label,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.style,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.fillColor,
    this.useLabelAsHint = false,
    this.shadowColor,
    this.prefixIconPadding,
    this.validator,
    this.inputFormatters,
    this.hintStyle,
    this.onChanged,
    this.onFieldSubmitted,
    this.borderRadius,
    this.borderColor,
    this.focusedBorderColor,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText || widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && !widget.useLabelAsHint)
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 8.0, right: 4.0),
            child: Text(
              widget.label!,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? AppConstants.borderRadius,
            ),
            boxShadow: widget.shadowColor != null
                ? [
                    BoxShadow(
                      color: widget.shadowColor!.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            maxLines: widget.maxLines,
            keyboardType: widget.keyboardType,
            obscureText: (widget.isPassword || widget.obscureText)
                ? _obscureText
                : false,
            style: widget.style ?? const TextStyle(),
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onFieldSubmitted,
            validator: widget.validator,
            inputFormatters: [
              SecurityTextInputFormatter(),
              ...?widget.inputFormatters,
            ],
            decoration: InputDecoration(
              hintText: widget.useLabelAsHint ? widget.label : widget.hint,
              hintStyle:
                  widget.hintStyle ??
                  const TextStyle(color: AppColors.textHint),
              fillColor: widget.fillColor ?? (Theme.of(context).brightness == Brightness.dark ? Theme.of(context).cardColor : AppColors.surface),
              filled: true,
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding:
                          widget.prefixIconPadding ??
                          const EdgeInsets.all(12.0),
                      child: widget.prefixIcon,
                    )
                  : null,
              suffixIcon: (widget.isPassword || widget.obscureText)
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                    )
                  : widget.suffixIcon,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? AppConstants.borderRadius,
                ),
                borderSide: widget.borderColor != null
                    ? BorderSide(color: widget.borderColor!)
                    : BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? AppConstants.borderRadius,
                ),
                borderSide: widget.borderColor != null
                    ? BorderSide(color: widget.borderColor!)
                    : (Theme.of(context).brightness == Brightness.dark 
                        ? BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1)
                        : BorderSide.none),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? AppConstants.borderRadius,
                ),
                borderSide: BorderSide(
                  color: widget.focusedBorderColor ?? AppColors.primary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? AppConstants.borderRadius,
                ),
                borderSide: const BorderSide(color: AppColors.error, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
