/// WebStore Reset Password Screen
///
/// Final step in the password reset flow.
/// Fields: password, password_confirmation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_snack_bar/app_snack_bar.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/modules/webstore/auth/presentation/state/webstore_auth_state.dart';
import 'package:erp/modules/webstore/auth/presentation/view_model/webstore_auth_providers.dart';

class WebStoreResetPasswordScreen extends ConsumerStatefulWidget {
  final String identifier;
  final String code;

  const WebStoreResetPasswordScreen({
    super.key,
    required this.identifier,
    required this.code,
  });

  @override
  ConsumerState<WebStoreResetPasswordScreen> createState() =>
      _WebStoreResetPasswordScreenState();
}

class _WebStoreResetPasswordScreenState
    extends ConsumerState<WebStoreResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onReset() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(webStoreAuthViewModelProvider.notifier).resetPassword(
            identifier: widget.identifier,
            code: widget.code,
            password: _passwordController.text,
            passwordConfirmation: _confirmPasswordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(webStoreAuthViewModelProvider);
    final isLoading = state is WebStoreAuthLoading;

    ref.listen<WebStoreAuthState>(webStoreAuthViewModelProvider, (prev, next) {
      if (next is WebStoreAuthPasswordResetSuccess) {
        AppSnackBar.showSuccess(context, next.message);
        AppNavigator.popToRoot(context);
      } else if (next is WebStoreAuthError) {
        AppSnackBar.showError(context, next.message);
      }
    });

    return WebStoreBaseScaffold(
      showBack: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ─── Icon ──────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_open_rounded,
                    size: 56,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),

                // ─── Header ────────────────────────
                Text(
                  LocaleKeys.webstore.auth.reset_password_title.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  LocaleKeys.webstore.auth.reset_password_subtitle.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),

                // ─── Password Field ────────────────
                AppTextField(
                  controller: _passwordController,
                  label: LocaleKeys.webstore.auth.password_label.tr(),
                  hint: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: AppColors.textSecondary),
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.common.passwordRequired.tr();
                    }
                    if (value.length < 6) {
                      return LocaleKeys.common.passwordInvalid.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ─── Confirm Password Field ────────
                AppTextField(
                  controller: _confirmPasswordController,
                  label: LocaleKeys.webstore.auth.confirm_password_label.tr(),
                  hint: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: AppColors.textSecondary),
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.common.confirmPasswordRequired.tr();
                    }
                    if (value != _passwordController.text) {
                      return LocaleKeys.common.passwordsDoNotMatch.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // ─── Reset Button ──────────────────
                AppButton(
                  onPressed: _onReset,
                  type: ButtonType.primary,
                  isLoading: isLoading,
                  isGradient: true,
                  child: Text(
                    LocaleKeys.webstore.auth.save_password_button.tr(),
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
      ),
    );
  }
}
