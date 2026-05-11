import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';

class SideCategoryList extends ConsumerWidget {
  const SideCategoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(catalogCategoriesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (state.isLoading && state.items.isEmpty) {
      return Container(
        width: 85.w,
        color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey[50],
        child: const Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    return Container(
      width: 85.w,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey[50],
        border: Border(
          left: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!,
          ),
        ),
      ),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final category = state.items[index];
          final isSelected = state.selectedCategoryId == category.id;

          return GestureDetector(
            onTap: () {
              ref.read(catalogCategoriesProvider.notifier).selectCategory(category.id);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.primaryOrange.withValues(alpha: 0.1) : Colors.white)
                    : Colors.transparent,
                border: Border(
                  right: BorderSide(
                    color: isSelected ? AppColors.primaryOrange : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 45.h,
                    width: 45.h,
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryOrange.withValues(alpha: 0.1) : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: AppImage(
                      imagePath: category.image ?? '',
                      fit: BoxFit.contain,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.sp,
                      height: 1.2,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? AppColors.primaryOrange : theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
