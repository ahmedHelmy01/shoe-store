import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'address_form_constants.dart';

/// Styled text field for address forms (icon + pill radius + light shadow).
class AddressFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool isRequired;

  const AddressFormTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: AppTextField(
        controller: controller,
        label: isRequired ? '$label *' : label,
        hint: hint,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        borderRadius: AddressFormConstants.fieldRadius,
        prefixIcon: Icon(icon, color: AppColors.primaryWine, size: 20.sp),
        prefixIconPadding: EdgeInsets.all(14.w),
        shadowColor: AppColors.primaryWine,
      ),
    );
  }
}
