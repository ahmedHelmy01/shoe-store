import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/product_card_widget.dart';

class ProductGridSection extends ConsumerWidget {
  const ProductGridSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeVmProvider);
    final products = homeState.products;

    if (homeState.isLoading && products.isEmpty) {
      return _buildShimmerSlider();
    }

    if (products.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Center(
          child: Text(
            'لا توجد منتجات حالياً',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    // Convert to a Horizontal Slider as requested by the user ("الجزء السليدر horzital")
    return SizedBox(
      height: 280.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: products.length,
        separatorBuilder: (_, __) => 12.horizontalSpace,
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
            width: 170.w,
            child: ProductGridCard(
              product: product,
              ranking: index + 1, // Add rankings for "Most Requested" feel
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerSlider() {
    return SizedBox(
      height: 280.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 4,
        separatorBuilder: (_, __) => 12.horizontalSpace,
        itemBuilder: (_, __) => Container(
          width: 170.w,
          decoration: BoxDecoration(
            color: AppColors.primaryBlueLight.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      ),
    );
  }
}
