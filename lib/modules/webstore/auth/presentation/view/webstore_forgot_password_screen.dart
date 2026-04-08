/// WebStore Forgot Password Screen
///
/// Sends a password reset OTP code to the customer's email or mobile.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_snack_bar/app_snack_bar.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/modules/webstore/auth/presentation/state/webstore_auth_state.dart';
import 'package:erp/modules/webstore/auth/presentation/view_model/webstore_auth_providers.dart';
import 'package:erp/modules/webstore/auth/presentation/widgets/webstore_auth_scaffold.dart';
import 'package:erp/modules/webstore/auth/presentation/widgets/auth_glass_card.dart';

class WebStoreForgotPasswordScreen extends ConsumerStatefulWidget {
  const WebStoreForgotPasswordScreen({super.key});

  @override
  ConsumerState<WebStoreForgotPasswordScreen> createState() =>
      _WebStoreForgotPasswordScreenState();
}

class _WebStoreForgotPasswordScreenState
    extends ConsumerState<WebStoreForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _onSend() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(webStoreAuthViewModelProvider.notifier).forgotPassword(
            username: _usernameController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(webStoreAuthViewModelProvider);
    final isLoading = state is WebStoreAuthLoading;

    ref.listen<WebStoreAuthState>(webStoreAuthViewModelProvider, (prev, next) {
      if (next is WebStoreOtpSent) {
        AppSnackBar.showSuccess(context, next.message);
        AppNavigator.push(
          context,
          AppRouteNames.webstoreOtp,
          arguments: {
            'identifier': next.identifier,
            'type': next.type,
          },
        );
      } else if (next is WebStoreAuthError) {
        AppSnackBar.showError(context, next.message);
      }
    });

    return WebStoreAuthScaffold(
      child: Form(
        key: _formKey,
        child: AuthGlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                // ─── Header ────────────────────────
                Text(
                  LocaleKeys.webstore.auth.forgot_password_title.tr(context: context),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  LocaleKeys.webstore.auth.forgot_password_subtitle.tr(context: context),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // ─── Username Field ────────────────
                AppTextField(
                  controller: _usernameController,
                  label: LocaleKeys.webstore.auth.mobile_label.tr(context: context),
                  hint: '01xxxxxxxxx',
                  prefixIcon: const Icon(Icons.phone_android_outlined,
                      color: AppColors.textSecondary),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return LocaleKeys.common.phoneRequired.tr(context: context);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // ─── Send Button ───────────────────
                AppButton(
                  onPressed: _onSend,
                  type: ButtonType.primary,
                  isLoading: isLoading,
                  isGradient: true,
                  child: Text(
                    LocaleKeys.webstore.auth.send_code_button.tr(context: context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
