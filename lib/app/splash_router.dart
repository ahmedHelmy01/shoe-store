import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/common_widget/main_layout/webstore_main_layout.dart';
import 'package:erp/modules/webstore/onboarding/presentation/view/onboarding_view.dart';
import 'package:erp/modules/webstore/splash/animated_splash_screen.dart';
import 'package:erp/modules/webstore/splash/splash_logic.dart';

class SplashRouter extends ConsumerStatefulWidget {
  const SplashRouter({super.key});

  @override
  ConsumerState<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends ConsumerState<SplashRouter>
    with SplashLogic<SplashRouter> {
  bool _splashDone = false;
  bool? _isOnboardingDone;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final status = await ref.read(sessionManagerProvider).hasSeenOnboarding();
    if (mounted) {
      setState(() => _isOnboardingDone = status);
    }
  }

  Future<void> _onSplashComplete() async {
    if (!mounted) return;
    await initializeSplash();
    if (!mounted) return;
    setState(() => _splashDone = true);
  }

  @override
  Widget build(BuildContext context) {
    // 1) Show Splash until animation is done
    if (!_splashDone || _isOnboardingDone == null) {
      return AnimatedSplashScreen(
        key: const ValueKey('splash'),
        onComplete: _onSplashComplete,
      );
    }
    // 2) Route based on Onboarding status
    if (!(_isOnboardingDone!)) {
      return const OnBoarding(key: ValueKey('onboarding'));
    }
    return const WebStoreMainLayout(key: ValueKey('main'));
  }
}
