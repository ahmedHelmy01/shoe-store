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
import 'package:erp/core/localization/locale_keys.dart';

import 'package:erp/modules/webstore/auth/presentation/state/webstore_auth_state.dart';
import 'package:erp/modules/webstore/auth/presentation/view_model/webstore_auth_providers.dart';
import 'package:erp/modules/webstore/auth/presentation/widgets/webstore_auth_scaffold.dart';
import 'package:erp/modules/webstore/auth/presentation/widgets/auth_glass_card.dart';

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

    return WebStoreAuthScaffold(
      showBack: true,
      child: Form(
        key: _formKey,
        child: AuthGlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LocaleKeys.webstore.auth.login_title.tr(context: context),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                LocaleKeys.webstore.auth.login_subtitle.tr(context: context),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.72),
                    ),
              ),
              const SizedBox(height: 22),

              AppTextField(
                controller: _loginNameController,
                label: LocaleKeys.webstore.auth.mobile_label.tr(context: context),
                hint: '01xxxxxxxxx',
                prefixIcon: const Icon(Icons.phone_android_outlined),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return LocaleKeys.common.phoneRequired.tr(context: context);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              AppTextField(
                controller: _passwordController,
                label: LocaleKeys.webstore.auth.password_label.tr(context: context),
                hint: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline),
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.common.passwordRequired.tr(context: context);
                  }
                  return null;
                },
              ),

              const SizedBox(height: 6),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () {
                    AppNavigator.push(
                      context,
                      AppRouteNames.webstoreForgotPassword,
                    );
                  },
                  child: Text(LocaleKeys.webstore.auth.forgot_password_title.tr(context: context)),
                ),
              ),

              const SizedBox(height: 10),
              AppButton(
                onPressed: _onLogin,
                type: ButtonType.primary,
                isLoading: isLoading,
                isGradient: true,
                child: Text(
                  LocaleKeys.webstore.auth.login_button.tr(context: context),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.webstore.auth.no_account.tr(context: context),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.75),
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      AppNavigator.push(context, AppRouteNames.webstoreRegister);
                    },
                    child: Text(
                      LocaleKeys.webstore.auth.register_now.tr(context: context),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
