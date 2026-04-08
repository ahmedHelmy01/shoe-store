import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/home/data/models/webstore_mock_data.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/category_view_vm.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';

class WebStoreCategoriesView extends ConsumerWidget {
  const WebStoreCategoriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Custom Header (Search Bar)
            _buildHeader(context),

            // 2. Main Content (Sidebar + Grid)
            Expanded(
              child: Row(
                children: [
                   // Sidebar (Right-aligned for Arabic RTL)
                  _buildSidebar(ref, context),
                  
                  // Content Grid (Left-aligned)
                  Expanded(
                    child: _buildCategoryContent(ref, context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Icon(Icons.mail_outline_rounded, color: theme.iconTheme.color, size: 24.sp),
          12.horizontalSpace,
          Expanded(
            child: Container(
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: isDark ? theme.cardColor : Colors.grey[100],
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: theme.hintColor, size: 20.sp),
                  8.horizontalSpace,
                  Text(
                    'بحث عن منتجات...',
                    style: TextStyle(color: theme.hintColor, fontSize: 13.sp),
                  ),
                  const Spacer(),
                  Icon(Icons.camera_alt_outlined, color: theme.hintColor, size: 20.sp),
                ],
              ),
            ),
          ),
          12.horizontalSpace,
          Icon(Icons.favorite_border_rounded, color: theme.iconTheme.color, size: 24.sp),
        ],
      ),
    );
  }

  // ─── Sidebar ─────────────────────────────────────────

  Widget _buildSidebar(WidgetRef ref, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedId = ref.watch(selectedCategoryIdProvider);
    final categories = WebStoreMockData.categories;

    return Container(
      width: 100.w,
      color: isDark ? theme.cardColor.withValues(alpha: 0.5) : Colors.grey[50],
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedId == category.id;

          return InkWell(
            onTap: () => ref.read(selectedCategoryIdProvider.notifier).select(category.id),
            child: Container(
              height: 56.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? theme.scaffoldBackgroundColor : Colors.transparent,
              ),
              child: Stack(
                children: [
                  if (isSelected)
                    Positioned(
                      right: 0,
                      top: 16.h,
                      bottom: 16.h,
                      child: Container(
                        width: 4.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.r),
                            bottomLeft: Radius.circular(4.r),
                          ),
                        ),
                      ),
                    ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? theme.textTheme.bodyLarge?.color : theme.hintColor,
                        ),
                      ),
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

  // ─── Main Content ────────────────────────────────────

  Widget _buildCategoryContent(WidgetRef ref, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final category = ref.watch(categoryContentProvider);

    return AppAnimation.fadeInUp(
      key: ValueKey(category.id),
      child: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Banner or Title
          Text(
            'Picks for you',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          16.verticalSpace,

          // Sub-category Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.63,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 16.h,
            ),
            itemCount: category.subCategories.length,
            itemBuilder: (context, index) {
              final sub = category.subCategories[index];
              return InkWell(
                onTap: () {
                  // Navigate to sub-category products
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Column(
                  children: [
                    Container(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? theme.cardColor : Colors.grey[100],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          sub.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                            Icon(Icons.category_outlined, color: theme.hintColor.withValues(alpha: 0.5)),
                        ),
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      sub.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
