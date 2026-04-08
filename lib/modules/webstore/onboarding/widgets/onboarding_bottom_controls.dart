import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';

class OnboardingBottomControls extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onStart;

  const OnboardingBottomControls({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          SmoothPageIndicator(
            controller: pageController,
            count: totalPages,
            effect: ExpandingDotsEffect(
              activeDotColor: Colors.white,
              dotColor: Colors.white.withOpacity(0.2),
              dotHeight: 6,
              dotWidth: 6,
              expansionFactor: 4,
              spacing: 12,
            ),
          ),
          const SizedBox(height: 48),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: currentPage == totalPages - 1
                ? _buildStartButton()
                : _buildNextButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      key: const ValueKey('next'),
      width: double.infinity,
      height: 64,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.08),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LocaleKeys.common.next.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_back_ios_new, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      key: const ValueKey('start'),
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 25,
            spreadRadius: -5,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onStart,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0D1B2A),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.common.get_started.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.rocket_launch_rounded, size: 24),
          ],
        ),
      ),
    );
  }
}
