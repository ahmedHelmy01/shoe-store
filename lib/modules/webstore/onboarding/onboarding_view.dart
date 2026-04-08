import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/modules/webstore/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:erp/modules/webstore/onboarding/presentation/state/onboarding_state.dart';
import 'package:erp/modules/webstore/onboarding/widgets/animated_background.dart';
import 'package:erp/modules/webstore/onboarding/widgets/floating_particles.dart';
import 'package:erp/modules/webstore/onboarding/widgets/skip_button.dart';
import 'package:erp/modules/webstore/onboarding/widgets/onboarding_bottom_controls.dart';
import 'package:erp/modules/webstore/onboarding/widgets/onboarding_page_content.dart';
import 'package:erp/core/services/session_manager.dart';
import 'package:erp/modules/webstore/onboarding/data/models/boarding_model.dart';

class OnBoarding extends ConsumerStatefulWidget {
  const OnBoarding({super.key});

  @override
  ConsumerState<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends ConsumerState<OnBoarding>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // ─── Animation Controllers ────────────────────────────────────
  late AnimationController _contentAnimController;
  late AnimationController _floatingAnimController;

  // ─── Content Animations ───────────────────────────────────────
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _scaleAnim;

  // ─── Floating Particles Animation ────────────────────────────
  late Animation<double> _floatingAnim;

  final List<List<Color>> _onboardingGradients = [
    [const Color(0xFF0D1B2A), const Color(0xFF1E3E62)],
    [const Color(0xFF1A2A6C), const Color(0xFF112240)],
    [const Color(0xFF2E7D32), const Color(0xFF4CAF50)],
    [AppColors.primaryBlue, AppColors.primaryOrange],
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    Future.microtask(() {
      ref.read(onboardingVmProvider.notifier).getOnboardingData();
    });
  }

  void _initAnimations() {
    _contentAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentAnimController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentAnimController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentAnimController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _floatingAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )
      ..repeat(reverse: true);

    _floatingAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _floatingAnimController, curve: Curves.easeInOut),
    );

    _contentAnimController.forward();
  }

  @override
  void dispose() {
    _contentAnimController.dispose();
    _floatingAnimController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _contentAnimController.reset();
    _contentAnimController.forward();
  }

  void _navigateToHome() async {
    // ─── Standardized Session Management ────────────────────────
    await SessionManager.instance.setHasSeenOnboarding(true);

    if (!mounted) return;

    // ─── Standardized Navigation ──────────────────────────────
    AppNavigator.pushAndRemoveUntil(
      context,
      AppRouteNames.webstoreMain,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingVmProvider);

    if (state is OnboardingError) {
      return Scaffold(body: _buildErrorState(state.message));
    }

    final bool isLoading = state is OnboardingLoading;
    final List<BoardingModel> boardings = state is OnboardingSuccess 
        ? state.boardings 
        : [];

    return Scaffold(
      backgroundColor: _onboardingGradients[0][0],
      body: _buildOnboardingContent(boardings, isLoading: isLoading),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _onboardingGradients[0],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60.sp, color: Colors.white70),
            20.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryOrange),
              onPressed: () =>
                  ref.read(onboardingVmProvider.notifier).getOnboardingData(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingContent(List<BoardingModel> boardings, {bool isLoading = false}) {
    return Stack(
      children: [
        AnimatedBackground(
          currentPage: _currentPage,
          gradients: _onboardingGradients,
        ),
        FloatingParticles(floatAnimation: _floatingAnim),
        SafeArea(
          child: Column(
            children: [
              SkipButton(
                currentPage: _currentPage,
                totalPages: isLoading ? 1 : boardings.length,
                onSkip: _navigateToHome,
              ),
              Expanded(
                child: isLoading
                    ? OnboardingPageContent(
                        imageUrl: '',
                        title: '',
                        subtitle: '',
                        fadeAnimation: _fadeAnim,
                        slideAnimation: _slideAnim,
                        scaleAnimation: _scaleAnim,
                        glowAnimation: _floatingAnim,
                        isLoading: true,
                      )
                    : AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double pageOffset = 0;
                          if (_pageController.hasClients) {
                            pageOffset = _pageController.page ?? 0;
                          }

                          return PageView.builder(
                            controller: _pageController,
                            onPageChanged: _onPageChanged,
                            itemCount: boardings.length,
                            itemBuilder: (context, index) {
                              final page = boardings[index];
                              
                              final double position = index - pageOffset;
                              final double translation = position * 100.w;

                              return Transform.translate(
                                offset: Offset(translation, 0),
                                child: OnboardingPageContent(
                                  imageUrl: page.image,
                                  title: page.titleAr,
                                  subtitle: page.contentAr,
                                  fadeAnimation: _fadeAnim,
                                  slideAnimation: _slideAnim,
                                  scaleAnimation: _scaleAnim,
                                  glowAnimation: _floatingAnim,
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
              OnboardingBottomControls(
                pageController: _pageController,
                currentPage: _currentPage,
                totalPages: isLoading ? 1 : boardings.length,
                onNext: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.fastOutSlowIn,
                  );
                },
                onStart: _navigateToHome,
              ),
              40.verticalSpace,
            ],
          ),
        ),
      ],
    );
  }
}
