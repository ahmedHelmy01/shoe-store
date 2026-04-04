/// WebStore Login Screen
///
/// Customer login screen for the WebStore module.
/// Supports login with email or mobile number.
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

class WebStoreLoginScreen extends ConsumerStatefulWidget {
  const WebStoreLoginScreen({super.key});

  @override
  ConsumerState<WebStoreLoginScreen> createState() =>
      _WebStoreLoginScreenState();
}

class _WebStoreLoginScreenState extends ConsumerState<WebStoreLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(webStoreAuthViewModelProvider.notifier).login(
            loginName: _loginNameController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(webStoreAuthViewModelProvider);
    final isLoading = state is WebStoreAuthLoading;

    // Listen for state changes
    ref.listen<WebStoreAuthState>(webStoreAuthViewModelProvider, (prev, next) {
      if (next is WebStoreAuthError) {
        AppSnackBar.showError(context, next.message);
      }
    });

    return WebStoreBaseScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ─── Logo / Header ─────────────────
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  LocaleKeys.webstore.auth.login_title.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  LocaleKeys.webstore.auth.login_subtitle.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),

                // ─── Login Name Field ──────────────
                AppTextField(
                  controller: _loginNameController,
                  label: LocaleKeys.webstore.auth.mobile_label.tr(),
                  hint: '01xxxxxxxxx',
                  prefixIcon: const Icon(Icons.phone_android_outlined,
                      color: AppColors.textSecondary),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return LocaleKeys.common.phoneRequired.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

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
                    return null;
                  },
                ),

                // ─── Forgot Password ───────────────
                const SizedBox(height: 4),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton(
                    onPressed: () {
                      AppNavigator.push(
                        context,
                        AppRouteNames.webstoreForgotPassword,
                      );
                    },
                    child: Text(
                      LocaleKeys.webstore.auth.forgot_password_title.tr(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ─── Login Button ──────────────────
                AppButton(
                  onPressed: _onLogin,
                  type: ButtonType.primary,
                  isLoading: isLoading,
                  isGradient: true,
                  child: Text(
                    LocaleKeys.webstore.auth.login_button.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ─── Register Link ─────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.webstore.auth.no_account.tr(),
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        AppNavigator.push(
                          context,
                          AppRouteNames.webstoreRegister,
                        );
                      },
                      child: Text(
                        LocaleKeys.webstore.auth.register_now.tr(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
