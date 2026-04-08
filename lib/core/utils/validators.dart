import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class AppValidators {
  // 📧 Email regex
  static final RegExp _emailRegExp = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");

  // 🔑 Password regex
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$&*~]).{8,}$',
  );

  // ☎️ Phone regex
  static final RegExp _phoneRegExp = RegExp(r'^\d{10,}$');

  /// ✅ Validate Email
  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.common.emailRequired.tr(context: context); //  Email is required
    } else if (!_emailRegExp.hasMatch(value)) {
      return LocaleKeys.common.invalidEmail.tr(context: context); // Invalid email
    }
    return null;
  }

  /// ✅ Validate Password
  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.common.passwordRequired.tr(context: context); //  Password is required
    } else if (!_passwordRegExp.hasMatch(value)) {
      return LocaleKeys.common.passwordInvalid.tr(context: context);
      // Password must contain uppercase, lowercase, number & special character
    }
    return null;
  }

  /// ✅ Validate Confirm Password
  static String? validateConfirmPassword(BuildContext context, String? value, String original) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.common.confirmPasswordRequired.tr(context: context);
      //  Confirm password is required
    } else if (value != original) {
      return LocaleKeys.common.passwordsDoNotMatch.tr(context: context);
      //  Passwords do not match
    }
    return null;
  }

  /// ✅ Validate Phone
  static String? validatePhone(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.common.phoneRequired.tr(context: context);
      //  Please enter phone number
    } else if (!_phoneRegExp.hasMatch(value)) {
      return LocaleKeys.common.invalidPhone.tr(context: context);
      //  Enter valid phone (at least 10 digits)
    }
    return null;
  }

  /// ✅ Validate Name
  static String? validateName(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.common.nameRequired.tr(context: context); //  Enter name
    }
    return null;
  }

  /// ✅ Validate description
  static String? validateDescription(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.common.enterDescription.tr(context: context); //  Enter description
    }
    return null;
  }
}
