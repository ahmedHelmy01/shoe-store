import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/data/models/category_model.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';

class SubcategoryHorizontalList extends ConsumerWidget {
  const SubcategoryHorizontalList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(catalogCategoriesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    if (state.items.isEmpty || state.selectedCategoryId == null) {
      return const SizedBox.shrink();
    }

    final selectedId = state.selectedCategoryId;
    
    // Find the active parent category (either the selected id matches the parent, or matches one of the parent's children)
    WebStoreCategory? activeParent;
    for (final parent in state.items) {
      if (parent.id == selectedId || parent.children.any((child) => child.id == selectedId)) {
        activeParent = parent;
        break;
      }
    }

    if (activeParent == null || activeParent.children.isEmpty) {
      return const SizedBox.shrink();
    }

    // Build the subcategories list. The first item is "All" (representing the parent category itself)
    final subcategories = [
      WebStoreCategory(
        id: activeParent.id,
        name: isAr ? 'الكل' : 'All',
        nameAr: 'الكل',
        nameEn: 'All',
      ),
      ...activeParent.children,
    ];

    return Container(
      height: 48.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100]!,
            width: 1,
          ),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: subcategories.length,
        separatorBuilder: (context, index) => 8.horizontalSpace,
        itemBuilder: (context, index) {
          final subcat = subcategories[index];
          final isSelected = selectedId == subcat.id;

          return GestureDetector(
            onTap: () {
              ref.read(catalogCategoriesProvider.notifier).selectCategory(subcat.id);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryOrange
                    : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100]),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryOrange
                      : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!),
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryOrange.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: Text(
                subcat.name,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
