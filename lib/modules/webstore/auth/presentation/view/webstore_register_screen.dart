/// WebStore Register Screen
///
/// Customer registration screen for the WebStore module.
/// Fields: name, email, mobile, password, password_confirmation.
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

class WebStoreRegisterScreen extends ConsumerStatefulWidget {
  const WebStoreRegisterScreen({super.key});

  @override
  ConsumerState<WebStoreRegisterScreen> createState() =>
      _WebStoreRegisterScreenState();
}

class _WebStoreRegisterScreenState
    extends ConsumerState<WebStoreRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(webStoreAuthViewModelProvider.notifier).register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            mobile: _mobileController.text.trim(),
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
      if (next is WebStoreAuthError) {
        AppSnackBar.showError(context, next.message);
      }
      if (next is WebStoreAuthSuccess) {
        AppSnackBar.showSuccess(
          context,
          LocaleKeys.webstore.auth.register_success.tr(context: context),
        );
      }
    });

    return WebStoreAuthScaffold(
      child: Form(
        key: _formKey,
        child: AuthGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ─── Header ──────────────────────────
              Text(
                LocaleKeys.webstore.auth.register_title.tr(context: context),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                LocaleKeys.webstore.auth.register_subtitle.tr(context: context),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // ─── Name ────────────────────────────
              AppTextField(
                controller: _nameController,
                label: LocaleKeys.webstore.auth.name_label.tr(context: context),
                hint: LocaleKeys.common.name.tr(context: context),
                prefixIcon: const Icon(Icons.person_outline,
                    color: AppColors.textSecondary),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return LocaleKeys.common.nameRequired.tr(context: context);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ─── Email ───────────────────────────
              AppTextField(
                controller: _emailController,
                label: LocaleKeys.common.email.tr(context: context),
                hint: 'ahmed@example.com',
                prefixIcon: const Icon(Icons.email_outlined,
                    color: AppColors.textSecondary),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return LocaleKeys.common.emailRequired.tr(context: context);
                  }
                  if (!value.contains('@')) {
                    return LocaleKeys.common.invalidEmail.tr(context: context);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ─── Mobile ──────────────────────────
              AppTextField(
                controller: _mobileController,
                label: LocaleKeys.webstore.auth.mobile_label.tr(context: context),
                hint: '0102345678',
                prefixIcon: const Icon(Icons.phone_outlined,
                    color: AppColors.textSecondary),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return LocaleKeys.common.phoneRequired.tr(context: context);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ─── Password ────────────────────────
              AppTextField(
                controller: _passwordController,
                label: LocaleKeys.webstore.auth.password_label.tr(context: context),
                hint: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline,
                    color: AppColors.textSecondary),
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.common.passwordRequired.tr(context: context);
                  }
                  if (value.length < 6) {
                    return LocaleKeys.common.passwordInvalid.tr(context: context);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ─── Confirm Password ────────────────
              AppTextField(
                controller: _confirmPasswordController,
                label: LocaleKeys.webstore.auth.confirm_password_label.tr(context: context),
                hint: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline,
                    color: AppColors.textSecondary),
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.common.confirmPasswordRequired.tr(context: context);
                  }
                  if (value != _passwordController.text) {
                    return LocaleKeys.common.passwordsDoNotMatch.tr(context: context);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // ─── Register Button ─────────────────
              AppButton(
                onPressed: _onRegister,
                type: ButtonType.primary,
                isLoading: isLoading,
                isGradient: true,
                child: Text(
                  LocaleKeys.webstore.auth.register_button.tr(context: context),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ─── Login Link ──────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.webstore.auth.have_account.tr(context: context),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  TextButton(
                    onPressed: () => AppNavigator.pop(context),
                    child: Text(
                      LocaleKeys.webstore.auth.login_now.tr(context: context),
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
    );
  }
}
