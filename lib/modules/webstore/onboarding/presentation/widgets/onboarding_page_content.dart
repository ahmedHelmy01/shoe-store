import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';

class OnboardingPageContent extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Animation<double> scaleAnimation;
  final Animation<double> glowAnimation;
  final bool isLoading;

  const OnboardingPageContent({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.scaleAnimation,
    required this.glowAnimation,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            60.verticalSpace,

            // ─── Animated Image Container with Glassmorphism ──────
            FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: SizedBox(
                  width: 280.w,
                  height: 280.w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. Dynamic Glow behind the glass
                      _buildBreathingGlow(),

                      // 2. Glassmorphism Container
                      ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            width: 280.w,
                            height: 280.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.15),
                                  Colors.white.withOpacity(0.03),
                                ],
                              ),
                            ),
                            child: isLoading
                                ? AppShimmer(
                                    baseColor: Colors.white.withOpacity(0.05),
                                    highlightColor: Colors.white.withOpacity(0.1),
                                    child: Container(
                                      width: 280.w,
                                      height: 280.w,
                                      color: Colors.white,
                                    ),
                                  )
                                : AppImage(imagePath: imageUrl, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            60.verticalSpace,

            // ─── Title ────────────────────────────────────────
            SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: isLoading
                    ? AppShimmer(
                        baseColor: Colors.white.withOpacity(0.01),
                        highlightColor: Colors.white.withOpacity(0.03),
                        child: Container(
                          width: 200.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      )
                    : Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
              ),
            ),

            20.verticalSpace,

            // ─── Subtitle ─────────────────────────────────────
            SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: isLoading
                    ? AppShimmer(
                        baseColor: Colors.white.withOpacity(0.01),
                        highlightColor: Colors.white.withOpacity(0.03),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 15.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            10.verticalSpace,
                            Container(
                              width: 250.w,
                              height: 15.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white.withOpacity(0.85),
                          height: 1.6,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreathingGlow() {
    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (context, child) {
        return Container(
          width: 240.w,
          height: 240.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.05 + (glowAnimation.value * 0.1)),
                blurRadius: 40 + (glowAnimation.value * 20),
                spreadRadius: 5 + (glowAnimation.value * 10),
              ),
            ],
          ),
        );
      },
    );
  }
}
