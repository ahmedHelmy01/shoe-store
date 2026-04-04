import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';

class CompanyProduceWidget extends ConsumerWidget {
  const CompanyProduceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companies = ref.watch(companyProducesVmProvider);

    if (companies.isEmpty) {
      return _buildLoading();
    }

    return SizedBox(
      height: 120.h,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        itemCount: companies.length,
        separatorBuilder: (_, __) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          final item = companies[index];
          return _buildAdvancedBrandCard(item);
        },
      ),
    );
  }

  Widget _buildAdvancedBrandCard(dynamic item) {
    return Container(
      width: 140.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: AppColors.primaryOrange.withOpacity(0.08),
          width: 1.5,
        ),
      ),
      child: Stack(
        children: [
          // Subtle background decoration
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              Icons.verified_user_outlined,
              size: 40,
              color: AppColors.primaryOrange.withOpacity(0.03),
            ),
          ),
          
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Container
              Container(
                height: 55.h,
                width: 90.w,
                padding: EdgeInsets.all(8.w),
                child: AppImage(
                  imagePath: item.logo,
                  fit: BoxFit.contain,
                ),
              ),
              
              4.verticalSpace,
              
              // Name with specialized styling
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textColor,
                        fontFamily: 'Harmattan',
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  4.horizontalSpace,
                  Icon(
                    Icons.verified,
                    size: 14.sp,
                    color: AppColors.primaryOrange,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 4,
      separatorBuilder: (_, __) => SizedBox(width: 16.w),
      itemBuilder: (_, __) => Container(
        height: 100.h,
        width: 140.w,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
