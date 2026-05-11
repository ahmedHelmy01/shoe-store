import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_snack_bar/app_snack_bar.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/auth/presentation/state/webstore_auth_state.dart';
import 'package:erp/modules/webstore/auth/presentation/view_model/webstore_auth_providers.dart';
import 'package:erp/modules/webstore/auth/presentation/widgets/webstore_auth_scaffold.dart';
import 'package:erp/modules/webstore/auth/presentation/widgets/auth_glass_card.dart';
import 'package:erp/modules/webstore/auth/presentation/widgets/auth_ui_components.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';

class WebStoreRegisterScreen extends ConsumerStatefulWidget {
  const WebStoreRegisterScreen({super.key});

  @override
  ConsumerState<WebStoreRegisterScreen> createState() => _WebStoreRegisterScreenState();
}

class _WebStoreRegisterScreenState extends ConsumerState<WebStoreRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  int? _selectedBranchId;

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
      if (_selectedBranchId == null) {
        AppSnackBar.showError(context, LocaleKeys.webstore.auth.branch_required.tr(context: context));
        return;
      }
      ref.read(webStoreAuthViewModelProvider.notifier).register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            mobile: _mobileController.text.trim(),
            password: _passwordController.text,
            passwordConfirmation: _confirmPasswordController.text,
            branchId: _selectedBranchId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(webStoreAuthViewModelProvider);
    final isLoading = state is WebStoreAuthLoading;
    final branchState = ref.watch(branchVmProvider);

    ref.listen<WebStoreAuthState>(webStoreAuthViewModelProvider, (prev, next) {
      if (next is WebStoreAuthError) {
        AppSnackBar.showError(context, next.message);
        ref.read(webStoreAuthViewModelProvider.notifier).resetState();
      }
      if (next is WebStoreAuthSuccess) {
        final serverMsg = next.authResponse.message;
        AppStatusDialog.showSuccess(
          context,
          title: LocaleKeys.webstore.auth.register_success_title.tr(context: context),
          message: serverMsg ?? LocaleKeys.webstore.auth.register_success_message.tr(context: context),
          onActionPressed: () {
            AppNavigator.replace(context, AppRouteNames.webstoreMain);
          },
        );
      }
    });

    return WebStoreAuthScaffold(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: AppAnimation.fadeInUp(
            duration: const Duration(milliseconds: 400),
            child: Form(
              key: _formKey,
              child: AuthGlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AuthHeader(
                      title: LocaleKeys.webstore.auth.register_title.tr(context: context),
                      subtitle: LocaleKeys.webstore.auth.register_subtitle.tr(context: context),
                    ),
                    const SizedBox(height: 20),
                    _buildFormFields(branchState),
                    const SizedBox(height: 20),
                    _buildRegisterButton(isLoading),
                    AuthFooter(
                      text: LocaleKeys.webstore.auth.have_account.tr(context: context),
                      actionText: LocaleKeys.webstore.auth.login_now.tr(context: context),
                      onActionTap: () => AppNavigator.pop(context),
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

  Widget _buildFormFields(BranchState branchState) {
    return Column(
      children: [
        AppTextField(
          controller: _nameController,
          label: LocaleKeys.webstore.auth.name_label.tr(context: context),
          useLabelAsHint: true,
          prefixIcon: const Icon(Icons.person_rounded, size: 20),
          validator: (value) => (value == null || value.trim().isEmpty)
              ? LocaleKeys.common.nameRequired.tr(context: context)
              : null,
        ),
        const SizedBox(height: 10),
        AppTextField(
          controller: _emailController,
          label: LocaleKeys.common.email.tr(context: context),
          useLabelAsHint: true,
          prefixIcon: const Icon(Icons.email_rounded, size: 20),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => (value == null || value.trim().isEmpty || !value.contains('@'))
              ? LocaleKeys.common.emailRequired.tr(context: context)
              : null,
        ),
        const SizedBox(height: 10),
        AppTextField(
          controller: _mobileController,
          label: LocaleKeys.webstore.auth.mobile_label.tr(context: context),
          useLabelAsHint: true,
          prefixIcon: const Icon(Icons.phone_android_rounded, size: 20),
          keyboardType: TextInputType.phone,
          validator: (value) => (value == null || value.trim().isEmpty)
              ? LocaleKeys.common.phoneRequired.tr(context: context)
              : null,
        ),
        const SizedBox(height: 10),
        if (branchState is BranchLoaded)
          AppDropdown<int>(
            label: '',
            hint: LocaleKeys.webstore.auth.select_branch_hint.tr(context: context),
            value: _selectedBranchId,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            items: branchState.branches.map((branch) {
              return DropdownMenuItem<int>(
                value: branch.id,
                child: Text(
                  context.locale.languageCode == 'ar' ? branch.nameAr : branch.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedBranchId = value),
          ),
        const SizedBox(height: 10),
        AppTextField(
          controller: _passwordController,
          label: LocaleKeys.webstore.auth.password_label.tr(context: context),
          useLabelAsHint: true,
          prefixIcon: const Icon(Icons.lock_open_rounded, size: 20),
          isPassword: true,
          validator: (value) => (value == null || value.isEmpty || value.length < 6)
              ? LocaleKeys.common.passwordRequired.tr(context: context)
              : null,
        ),
        const SizedBox(height: 10),
        AppTextField(
          controller: _confirmPasswordController,
          label: LocaleKeys.webstore.auth.confirm_password_label.tr(context: context),
          useLabelAsHint: true,
          prefixIcon: const Icon(Icons.check_circle_outline_rounded, size: 20),
          isPassword: true,
          validator: (value) => (value != _passwordController.text)
              ? LocaleKeys.common.passwordsDoNotMatch.tr(context: context)
              : null,
        ),
      ],
    );
  }

  Widget _buildRegisterButton(bool isLoading) {
    return AppButton(
      onPressed: _onRegister,
      type: ButtonType.primary,
      isLoading: isLoading,
      height: 48, // Compact button
      isGradient: true,
      child: Text(
        LocaleKeys.webstore.auth.register_button.tr(context: context),
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
      ),
    );
  }
}
