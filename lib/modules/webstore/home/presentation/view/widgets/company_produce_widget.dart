import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/modules/webstore/home/data/models/webstore_mock_data.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';

class CompanyProduceWidget extends ConsumerWidget {
  const CompanyProduceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companies = ref.watch(companyProducesVmProvider);

    if (companies.isEmpty) {
      return AppShimmer.list(height: 120.h, width: 140.w);
    }

    return AppAnimation.fadeInUp(
      child: _buildBrandsList(companies),
    );
  }

  Widget _buildBrandsList(List<MockCompany> brands) {
    return SizedBox(
      height: 120.h,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        itemCount: brands.length,
        separatorBuilder: (_, __) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          final item = brands[index];
          return _buildAdvancedBrandCard(context, item);
        },
      ),
    );
  }

  Widget _buildAdvancedBrandCard(BuildContext context, dynamic item) {
    return AppCard(
      width: 140.w,
      border: Border.all(
        color: AppColors.primaryOrange.withOpacity(0.08),
        width: 1.5,
      ),
      onTap: () {},
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
                child: Image.network(
                  item.logo,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        item.name.isNotEmpty ? item.name[0].toUpperCase() : '?',
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ),
                  ),
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
                        color: Theme.of(context).textTheme.bodyMedium?.color,
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
}
