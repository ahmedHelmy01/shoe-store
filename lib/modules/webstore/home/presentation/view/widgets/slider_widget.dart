import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/home/presentation/state/slider_state.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/modules/webstore/home/data/models/slider_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_empty_widget/app_empty_widget.dart';

class SliderSection extends ConsumerStatefulWidget {
  const SliderSection({super.key});

  @override
  ConsumerState<SliderSection> createState() => _SliderSectionState();
}

class _SliderSectionState extends ConsumerState<SliderSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      final isScrolling = ref.read(homeScrollProvider);
      if (isScrolling) return;

      if (_pageController.hasClients) {
        final state = ref.read(sliderVmProvider);
        if (state is SliderSuccess && state.sliders.isNotEmpty) {
          final nextGroup = (_currentPage + 1) % state.sliders.length;
          _pageController.animateToPage(
            nextGroup,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sliderVmProvider);

    return switch (state) {
      SliderLoading() || SliderInitial() => AppShimmer.slider(),
      SliderError(:final message) => Center(child: Text(message)),
      SliderSuccess(:final sliders) => _buildSlider(sliders),
    };
  }

  Widget _buildSlider(List<SliderModel> sliders) {
    if (sliders.isEmpty) {
      // ─── Unified Empty State ──────────────────────────
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: AppEmptyWidget(
          message: LocaleKeys.webstore.home.no_offers.tr(context: context),
          subtitle: LocaleKeys.webstore.home.wait_for_offers.tr(context: context),
          showGlassBackground: false,
        ),
      );
    }

    return AppAnimation.fadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Column(
        children: [
          SizedBox(
            height: 200.h,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: sliders.length,
              itemBuilder: (context, index) {
                final data = sliders[index];
                return _buildSliderItem(
                  image: data.image,
                  title:
                      (context.locale.languageCode == 'ar'
                          ? data.titleAr
                          : data.title) ??
                      '',
                );
              },
            ),
          ),
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              sliders.length,
              (index) => _buildIndicator(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderItem({
    required String image,
    required String title,
    bool isDefault = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            AppImage(
              imagePath: image,
              width: double.infinity,
              height: double.infinity,
              fit: isDefault ? BoxFit.contain : BoxFit.cover,
              color: isDefault ? Colors.white.withValues(alpha: 0.9) : null,
            ),

            if (isDefault)
              Container(color: AppColors.primary.withValues(alpha: 0.02)),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.sp,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 6.h,
      width: _currentPage == index ? 20.w : 6.w,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? AppColors.primaryWine
            : Colors.grey[300],
        borderRadius: BorderRadius.circular(3.r),
      ),
    );
  }
}
