import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/utils/asset_manager.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/constants/configure_system_ui.dart';

class AnimatedSplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const AnimatedSplashScreen({super.key, required this.onComplete});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with TickerProviderStateMixin {
  // ─── Controllers ──────────────────────────────────
  late AnimationController _logoController;
  late AnimationController _textController;

  // ─── Logo Animations ──────────────────────────────
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoRotation;

  // ─── Text & Tagline Animations ────────────────────
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  // ─── Shimmer / Glow ───────────────────────────────
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    configureSystemUI();
    _initAnimations();
    _startSequence();
  }

  void _initAnimations() {
    // 1. Logo entrance (scale + fade + subtle rotation)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _logoRotation = Tween<double>(begin: -0.05, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    // 2. Text entrance (fade + slide up)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    // 3. Glow pulse effect
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  void _startSequence() async {
    // Start logo animation
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();

    // Start text after logo settles
    await Future.delayed(const Duration(milliseconds: 900));
    _textController.forward();

    // Hold for a moment - increased for better impact
    await Future.delayed(const Duration(milliseconds: 3000));

    // Navigate immediately without animation transition as requested
    widget.onComplete();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D1B2A), // Deep dark navy
              Color(0xFF1B2838), // Slightly lighter
              Color(0xFF0D1B2A), // Back to dark
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // ─── Background particles ──────────────────
            ..._buildBackgroundElements(),

            // ─── Main content ──────────────────────────
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ─── Glow effect behind logo ─────────
                    AnimatedBuilder(
                      animation: _glowAnimation,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryWine.withOpacity(
                                  _glowAnimation.value * 0.3,
                                ),
                                blurRadius: 60,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                          child: child,
                        );
                      },
                      child: // ─── Logo ──────────────────────
                          AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _logoRotation.value,
                            child: Opacity(
                              opacity: _logoOpacity.value,
                              child: Transform.scale(
                                scale: _logoScale.value,
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 200.w,
                          height: 200.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(20.w),
                          child: ClipOval(
                            child: AppImage(
                              imagePath: AssetManager.appIcons,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),

                    40.verticalSpace,

                    // ─── App Name ────────────────────────
                    SlideTransition(
                      position: _textSlide,
                      child: FadeTransition(
                        opacity: _textOpacity,
                        child: Column(
                          children: [
                            Text(
                              'متجر الأحذية',
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                            8.verticalSpace,
                            Text(
                              'متجر إلكتروني لبيع الأحذية',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primaryWine.withOpacity(0.9),
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── Bottom version text ───────────────────
            Positioned(
              bottom: 40.h,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _textOpacity,
                child: Text(
                  'v1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundElements() {
    return [
      // Top-right accent circle
      Positioned(
        top: -80.h,
        right: -60.w,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, _) {
            return Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryWine.withOpacity(
                  _glowAnimation.value * 0.08,
                ),
              ),
            );
          },
        ),
      ),
      // Bottom-left accent circle
      Positioned(
        bottom: -100.h,
        left: -80.w,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, _) {
            return Container(
              width: 250.w,
              height: 250.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue.withOpacity(
                  _glowAnimation.value * 0.1,
                ),
              ),
            );
          },
        ),
      ),
    ];
  }
}
