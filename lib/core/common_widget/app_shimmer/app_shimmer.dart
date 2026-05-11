import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: baseColor ?? (isDark ? const Color(0xFF1B263B) : Colors.grey.shade200),
      highlightColor: highlightColor ?? (isDark ? const Color(0xFF253341) : Colors.grey.shade50),
      child: child,
    );
  }

  /// Quick shimmer box
  static Widget box({
    double width = double.infinity,
    double height = 16,
    double borderRadius = 8,
  }) {
    return AppShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Specialized shimmer for the Hero Slider
  static Widget slider() {
    return AppShimmer(
      child: Container(
        height: 200.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }

  /// Specialized shimmer for circular Categories
  static Widget categoryCircle() {
    return SizedBox(
      height: 90.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 6,
        separatorBuilder: (_, __) => 16.horizontalSpace,
        itemBuilder: (_, __) => AppShimmer(
          child: Column(
            children: [
              Container(
                width: 70.w,
                height: 70.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              8.verticalSpace,
              Container(
                width: 40.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Specialized shimmer for rectangular Product Cards
  static Widget productCard() {
    return AppShimmer(
      child: Container(
        width: 150.w,
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 10.h, width: 80.w, color: Colors.white),
                    8.verticalSpace,
                    Container(height: 8.h, width: 40.w, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Specialized shimmer for the Vouchers
  static Widget voucherCard() {
    return SizedBox(
      height: 100.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 3,
        separatorBuilder: (_, __) => 12.horizontalSpace,
        itemBuilder: (_, __) => AppShimmer(
          child: Container(
            width: 220.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    );
  }

  /// Specialized shimmer for a list of items
  static Widget list({int itemCount = 4, double height = 120, double width = 140}) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: itemCount,
        separatorBuilder: (_, __) => 16.horizontalSpace,
        itemBuilder: (_, __) => AppShimmer(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    );
  }

  /// Specialized shimmer for the Feature Links Grid (Medical Services)
  static Widget featureLinksGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 4.h,
          crossAxisSpacing: 0.w,
          childAspectRatio: 0.8,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return AppShimmer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                8.verticalSpace,
                Container(
                  width: 60.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Specialized shimmer for Ads Carousel
  static Widget adsCarousel() {
    return AppShimmer(
      child: Container(
        height: 180.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }
}
