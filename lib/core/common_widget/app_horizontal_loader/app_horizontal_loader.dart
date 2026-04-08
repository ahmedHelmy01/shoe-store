import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';

class AppHorizontalLoader extends StatelessWidget {
  final double height;
  final double itemWidth;
  final double? itemHeight;
  final int itemCount;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const AppHorizontalLoader({
    super.key,
    required this.height,
    required this.itemWidth,
    this.itemHeight,
    this.itemCount = 5,
    this.borderRadius = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: itemCount,
        separatorBuilder: (_, __) => 16.horizontalSpace,
        itemBuilder: (_, __) => AppShimmer(
          child: Container(
            width: itemWidth,
            height: itemHeight ?? height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius.r),
            ),
          ),
        ),
      ),
    );
  }
}
