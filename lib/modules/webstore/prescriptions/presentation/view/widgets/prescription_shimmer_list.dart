import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';

class PrescriptionShimmerList extends StatelessWidget {
  const PrescriptionShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 16.h),
        child: Row(
          children: [
            AppShimmer.box(width: 90.w, height: 90.w, borderRadius: 12.r),
            16.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmer.box(width: 80.w, height: 20.h, borderRadius: 10.r),
                  10.verticalSpace,
                  AppShimmer.box(width: double.infinity, height: 16.h, borderRadius: 4.r),
                  6.verticalSpace,
                  AppShimmer.box(width: 150.w, height: 12.h, borderRadius: 4.r),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
