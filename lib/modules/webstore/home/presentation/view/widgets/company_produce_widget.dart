import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/data/models/manufacturer_model.dart';
import 'package:easy_localization/easy_localization.dart';

class CompanyProduceWidget extends ConsumerWidget {
  const CompanyProduceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companies = ref.watch(companyProducesVmProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (companies.isEmpty) {
      return SizedBox(
        height: 100.h,
        child: const Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: companies.map((company) => _buildCompanyItem(context, company, isDark, theme)).toList(),
      ),
    );
  }

  Widget _buildCompanyItem(BuildContext context, ManufacturerModel company, bool isDark, ThemeData theme) {
    final String name = context.locale.languageCode == 'ar' 
        ? (company.nameAr ?? company.name) 
        : (company.nameEn ?? company.name);

    // Filter out potential empty names
    if (name.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      width: 130.w,
      margin: EdgeInsets.only(right: 16.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.primaryOrange.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Unified Logo/Avatar Container
          Container(
            height: 55.w,
            width: 55.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryOrange.withValues(alpha: 0.05),
            ),
            child: ClipOval(
              child: company.logo != null && company.logo!.isNotEmpty
                  ? AppImage(
                      imagePath: company.logo!,
                      fit: BoxFit.contain,
                      width: 55.w,
                      height: 55.w,
                    )
                  : Center(
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'B',
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.w900,
                          fontSize: 22.sp,
                          fontFamily: 'store',
                        ),
                      ),
                    ),
            ),
          ),
          12.verticalSpace,
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textMain,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
