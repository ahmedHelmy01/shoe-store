import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_snack_bar/app_snack_bar.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/auth/presentation/state/webstore_auth_state.dart';
import 'package:erp/modules/webstore/auth/presentation/view_model/webstore_auth_providers.dart';
import 'package:erp/modules/webstore/auth/presentation/widgets/webstore_auth_scaffold.dart';
import 'package:erp/modules/webstore/auth/presentation/widgets/auth_glass_card.dart';
import 'package:erp/modules/webstore/auth/presentation/widgets/auth_ui_components.dart';
import 'package:erp/modules/webstore/auth/presentation/widgets/social_login_section.dart';
import 'package:erp/core/common_widget/app_bottom_sheet/branch_selection_sheet.dart';

class WebStoreLoginScreen extends ConsumerStatefulWidget {
  const WebStoreLoginScreen({super.key});

  @override
  ConsumerState<WebStoreLoginScreen> createState() => _WebStoreLoginScreenState();
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

  void _onSocialLogin(String provider) async {
    // 1. Show Branch Selection Sheet first
    final branchId = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BranchSelectionSheet(),
    );

    if (branchId == null) return; // User cancelled

    // 2. Proceed with social login using selected branch
    ref.read(webStoreAuthViewModelProvider.notifier).socialLogin(
          providerType: provider,
          providerIdentifier: 'dummy-id-${DateTime.now().millisecondsSinceEpoch}',
          name: 'Social User',
          branchId: branchId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(webStoreAuthViewModelProvider);
    final isLoading = state is WebStoreAuthLoading;

    ref.listen<WebStoreAuthState>(webStoreAuthViewModelProvider, (prev, next) {
      if (next is WebStoreAuthError) {
        AppSnackBar.showError(context, next.message);
        ref.read(webStoreAuthViewModelProvider.notifier).resetState();
      }
      if (next is WebStoreAuthSuccess) {
        AppNavigator.replace(context, AppRouteNames.webstoreMain);
      }
    });

    return WebStoreAuthScaffold(
      showBack: true,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: AppAnimation.fadeInUp(
            duration: const Duration(milliseconds: 400),
            child: Form(
              key: _formKey,
              child: AuthGlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthHeader(
                      title: LocaleKeys.webstore.auth.login_title.tr(context: context),
                      subtitle: LocaleKeys.webstore.auth.login_subtitle.tr(context: context),
                    ),
                    const SizedBox(height: 32),
                    _buildFormFields(),
                    const SizedBox(height: 20),
                    _buildLoginButton(isLoading),
                    const SizedBox(height: 32),
                    SocialLoginSection(
                      onGoogleTap: () => _onSocialLogin('google'),
                      onFacebookTap: () => _onSocialLogin('facebook'),
                      onAppleTap: () => _onSocialLogin('apple'),
                    ),
                    const SizedBox(height: 32),
                    AuthFooter(
                      text: LocaleKeys.webstore.auth.no_account.tr(context: context),
                      actionText: LocaleKeys.webstore.auth.register_now.tr(context: context),
                      onActionTap: () => AppNavigator.push(context, AppRouteNames.webstoreRegister),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        AppTextField(
          controller: _loginNameController,
          label: LocaleKeys.webstore.auth.mobile_label.tr(context: context),
          hint: '01xxxxxxxxx',
          prefixIcon: const Icon(Icons.phone_android_rounded),
          keyboardType: TextInputType.phone,
          validator: (value) => (value == null || value.trim().isEmpty)
              ? LocaleKeys.common.phoneRequired.tr(context: context)
              : null,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _passwordController,
          label: LocaleKeys.webstore.auth.password_label.tr(context: context),
          hint: '••••••••',
          prefixIcon: const Icon(Icons.lock_open_rounded),
          isPassword: true,
          validator: (value) => (value == null || value.isEmpty)
              ? LocaleKeys.common.passwordRequired.tr(context: context)
              : null,
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton(
            onPressed: () => AppNavigator.push(context, AppRouteNames.webstoreForgotPassword),
            child: Text(LocaleKeys.webstore.auth.forgot_password_title.tr(context: context)),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(bool isLoading) {
    return AppButton(
      onPressed: _onLogin,
      type: ButtonType.primary,
      isLoading: isLoading,
      isGradient: true,
      child: Text(
        LocaleKeys.webstore.auth.login_button.tr(context: context),
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
      ),
    );
  }
}
