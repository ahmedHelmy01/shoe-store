import 'package:erp/core/router/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/data/models/manufacturer_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';
import 'package:erp/core/common_widget/app_empty_widget/app_empty_widget.dart';
import 'package:erp/core/localization/locale_keys.dart';

class CompanyProduceWidget extends ConsumerWidget {
  const CompanyProduceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(companyProducesVmProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 1. Loading State with Shimmer Tiles
    if (state.isLoading && state.manufacturers.isEmpty) {
      return _buildShimmerLoading(isDark);
    }

    // 2. Empty State
    if (state.manufacturers.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: AppEmptyWidget(
          message: LocaleKeys.common.no_data.tr(context: context),
          showGlassBackground: false,
        ),
      );
    }

    // 3. Dynamic Official Manufacturer Cards
    return SizedBox(
      height: 105.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        itemCount: state.manufacturers.length,
        separatorBuilder: (_, _) => 14.horizontalSpace,
        itemBuilder: (context, index) {
          return _buildDynamicManufacturerCard(
            context,
            state.manufacturers[index],
            isDark,
            theme,
          );
        },
      ),
    );
  }

  /// Dynamic Premium Manufacturer Card using real API Data (Name & Description)
  Widget _buildDynamicManufacturerCard(
    BuildContext context,
    ManufacturerModel company,
    bool isDark,
    ThemeData theme,
  ) {
    final bool isAr = context.locale.languageCode == 'ar';
    final String name = isAr
        ? (company.nameAr ?? company.name)
        : (company.nameEn ?? company.name);

    final String? description = isAr
        ? (company.descriptionAr ?? company.description)
        : (company.description ?? company.descriptionAr);

    if (name.trim().isEmpty) return const SizedBox.shrink();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          AppNavigator.push(
            context,
            AppRouteNames.webstoreCatalogProducts,
            arguments: {
              'manufacturer_id': company.id,
              'category_title': name,
            },
          );
        },
        borderRadius: BorderRadius.circular(22.r),
        child: Container(
          width: 250.w,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppColors.primaryWine.withValues(alpha: 0.15),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.08),
                blurRadius: 16,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Logo Box Frame (Clean Isolated White Container)
              Container(
                width: 68.w,
                height: 68.w,
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.grey.withValues(alpha: 0.12),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: company.logo != null && company.logo!.isNotEmpty
                      ? AppImage(
                          imagePath: company.logo!,
                          fit: BoxFit.contain,
                        )
                      : Center(
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'B',
                            style: TextStyle(
                              color: AppColors.primaryWine,
                              fontWeight: FontWeight.w900,
                              fontSize: 24.sp,
                              fontFamily: 'store',
                            ),
                          ),
                        ),
                ),
              ),
              12.horizontalSpace,
              // Details Column: Dynamic Name + Real API Description
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Name
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : AppColors.textMain,
                        letterSpacing: -0.2,
                      ),
                    ),
                    4.verticalSpace,
                    // Dynamic Description from API Response
                    if (description != null && description.trim().isNotEmpty)
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white60 : Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              8.horizontalSpace,
              // Explore Arrow Icon Button
              Container(
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryWine.withValues(alpha: 0.08),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13.sp,
                  color: AppColors.primaryWine,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shimmer Skeleton Tiles
  Widget _buildShimmerLoading(bool isDark) {
    return SizedBox(
      height: 105.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        itemCount: 3,
        separatorBuilder: (_, _) => 14.horizontalSpace,
        itemBuilder: (_, _) {
          return AppShimmer.box(
            width: 250.w,
            height: 95.h,
            borderRadius: 22.r,
          );
        },
      ),
    );
  }
}
