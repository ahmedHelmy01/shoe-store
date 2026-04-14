import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/utils/asset_manager.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_sidebar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import '../view_model/auth_view_model.dart';
import '../widgets/login_background.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await ref.read(loginVmProvider.notifier).login(
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );
      if (!success && mounted) {
        final error = ref.read(loginVmProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error ?? 'Login Failed'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginVmProvider);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          const LoginBackground(),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1.5,
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _LogoHeader(),
                            const SizedBox(height: 48),
                            
                            AppTextField(
                              controller: _emailCtrl,
                              label: 'Email Address',
                              hint: 'admin@example.com',
                              keyboardType: TextInputType.emailAddress,
                              borderRadius: 16,
                              prefixIcon: HugeIcon(
                                icon: HugeIconsStrokeRounded.mail01,
                                color: AppColors.primaryOrange,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            AppTextField(
                              controller: _passCtrl,
                              label: 'Password',
                              hint: '••••••••',
                              isPassword: true,
                              borderRadius: 16,
                              prefixIcon: HugeIcon(
                                icon: HugeIconsStrokeRounded.lockPassword,
                                color: AppColors.primaryOrange,
                                size: 20,
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            const SizedBox(height: 32),
                            AppButton(
                              onPressed: _submit,
                              isLoading: state.isLoading,
                              child: const Text('Login to Dashboard'),
                            ),
                            
                            const SizedBox(height: 32),
                            Text(
                              'Authorized Personnel Only',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.4),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: AppColors.primaryOrange.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
          ),
          child: Image.asset(AssetManager.splashTarshouby, fit: BoxFit.contain),
        ),
        const SizedBox(height: 24),
        const Text(
          'WebStore Admin',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Control your store with precision',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
