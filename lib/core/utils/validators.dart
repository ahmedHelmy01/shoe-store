import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

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
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.common.emailRequired.tr(); //  Email is required
    } else if (!_emailRegExp.hasMatch(value)) {
      return LocaleKeys.common.invalidEmail.tr(); // Invalid email
    }
    return null;
  }

  /// ✅ Validate Password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.common.passwordRequired.tr(); //  Password is required
    } else if (!_passwordRegExp.hasMatch(value)) {
      return LocaleKeys.common.passwordInvalid.tr();
      // Password must contain uppercase, lowercase, number & special character
    }
    return null;
  }

  /// ✅ Validate Confirm Password
  static String? validateConfirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.common.confirmPasswordRequired.tr();
      //  Confirm password is required
    } else if (value != original) {
      return LocaleKeys.common.passwordsDoNotMatch.tr();
      //  Passwords do not match
    }
    return null;
  }

  /// ✅ Validate Phone
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.common.phoneRequired.tr();
      //  Please enter phone number
    } else if (!_phoneRegExp.hasMatch(value)) {
      return LocaleKeys.common.invalidPhone.tr();
      //  Enter valid phone (at least 10 digits)
    }
    return null;
  }

  /// ✅ Validate Name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.common.nameRequired.tr(); //  Enter name
    }
    return null;
  }

  /// ✅ Validate description
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.common.enterDescription.tr(); //  Enter description
    }
    return null;
  }
}
