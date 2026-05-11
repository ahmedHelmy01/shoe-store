/// WebStore OTP Screen
///
/// Verify an OTP code sent during registration or password reset.
/// Supports resend functionality with a countdown timer.
library;

import 'dart:async';
import 'dart:ui' as ui show TextDirection;
import 'package:flutter/material.dart' hide TextDirection;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_snack_bar/app_snack_bar.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/modules/webstore/auth/presentation/state/webstore_auth_state.dart';
import 'package:erp/modules/webstore/auth/presentation/view_model/webstore_auth_providers.dart';
import 'package:erp/modules/webstore/auth/presentation/widgets/webstore_auth_scaffold.dart';
import 'package:erp/modules/webstore/auth/presentation/widgets/auth_glass_card.dart';

class WebStoreOtpScreen extends ConsumerStatefulWidget {
  final String identifier;
  final String type;

  const WebStoreOtpScreen({
    super.key,
    required this.identifier,
    required this.type,
  });

  @override
  ConsumerState<WebStoreOtpScreen> createState() => _WebStoreOtpScreenState();
}

class _WebStoreOtpScreenState extends ConsumerState<WebStoreOtpScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  Timer? _resendTimer;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendCountdown = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendCountdown > 0) {
            _resendCountdown--;
          } else {
            _canResend = true;
            timer.cancel();
          }
        });
      }
    });
  }

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  void _onVerify() {
    final code = _otpCode;
    if (code.length < 4) {
      AppSnackBar.showError(
        context,
        LocaleKeys.webstore.auth.otp_subtitle.tr(context: context),
      );
      return;
    }

    ref.read(webStoreAuthViewModelProvider.notifier).verifyCode(
          identifier: widget.identifier,
          code: code,
          type: widget.type,
        );
  }

  void _onResend() {
    if (!_canResend) return;

    ref.read(webStoreAuthViewModelProvider.notifier).resendCode(
          identifier: widget.identifier,
          type: widget.type,
        );
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(webStoreAuthViewModelProvider);
    final isLoading = state is WebStoreAuthLoading;

    ref.listen<WebStoreAuthState>(webStoreAuthViewModelProvider, (prev, next) {
      if (next is WebStoreOtpVerified) {
        AppSnackBar.showSuccess(context, next.message);

        if (widget.type == 'password_reset') {
          AppNavigator.replace(
            context,
            AppRouteNames.webstoreResetPassword,
            arguments: {
              'identifier': widget.identifier,
              'code': _otpCode,
            },
          );
        } else {
          AppNavigator.popToRoot(context);
        }
      } else if (next is WebStoreOtpResent) {
        AppSnackBar.showSuccess(context, next.message);
      } else if (next is WebStoreAuthError) {
        AppSnackBar.showError(context, next.message);
      }
    });

    return WebStoreAuthScaffold(
      child: AuthGlassCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              // ─── Header ────────────────────────
              Text(
                LocaleKeys.webstore.auth.otp_title.tr(context: context),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${LocaleKeys.webstore.auth.otp_subtitle.tr(context: context)}\n${widget.identifier}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // ─── OTP Input Boxes ─────────────────
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Container(
                      width: 60,
                      height: 64,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: TextFormField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: AppColors.textHint, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                                color:
                                    AppColors.textHint.withValues(alpha: 0.3),
                                width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 2),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            _focusNodes[index + 1].requestFocus();
                          }
                          if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 32),

              // ─── Verify Button ───────────────────
              AppButton(
                onPressed: _onVerify,
                type: ButtonType.primary,
                isLoading: isLoading,
                isGradient: true,
                child: Text(
                  LocaleKeys.webstore.auth.verify_button.tr(context: context),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ─── Resend Code ─────────────────────
              Center(
                child: _canResend
                    ? TextButton(
                        onPressed: _onResend,
                        child: Text(
                          LocaleKeys.webstore.auth.send_code_button.tr(context: context),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Text(
                        '${LocaleKeys.webstore.auth.resend_timer.tr(context: context)} $_resendCountdown',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
