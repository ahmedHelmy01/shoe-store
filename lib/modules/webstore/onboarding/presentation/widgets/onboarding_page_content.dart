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
  final bool isLoading;

  const OnboardingPageContent({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.scaleAnimation,
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

            // ─── Image Container ────────────────────────────────
            FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: _buildImageCircle(),
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
                        baseColor: Colors.white.withValues(alpha: 0.01),
                        highlightColor: Colors.white.withValues(alpha: 0.03),
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
                        baseColor: Colors.white.withValues(alpha: 0.01),
                        highlightColor: Colors.white.withValues(alpha: 0.03),
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
                          color: Colors.white.withValues(alpha: 0.85),
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

  Widget _buildImageCircle() {
    return Container(
      width: 280.w,
      height: 280.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 60,
            spreadRadius: 8,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.18),
              Colors.white.withValues(alpha: 0.04),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1.5,
          ),
        ),
        child: ClipOval(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white.withValues(alpha: 0.06),
            child: isLoading
                ? AppShimmer(
                    baseColor: Colors.white.withValues(alpha: 0.05),
                    highlightColor: Colors.white.withValues(alpha: 0.1),
                    child: const SizedBox.expand(),
                  )
                : AppImage(imagePath: imageUrl, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
