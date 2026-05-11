import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';

class SideCategoryList extends ConsumerStatefulWidget {
  const SideCategoryList({super.key});

  @override
  ConsumerState<SideCategoryList> createState() => _SideCategoryListState();
}

class _SideCategoryListState extends ConsumerState<SideCategoryList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (!pos.hasContentDimensions || pos.maxScrollExtent <= 0) return;
    if (pos.pixels < pos.maxScrollExtent - 80) return;

    final state = ref.read(catalogCategoriesProvider);
    if (state.hasMore && !state.isLoadingMore && !state.isLoading) {
      ref.read(catalogCategoriesProvider.notifier).getCategories();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    final extraTrailing = state.isLoadingMore ? 1 : 0;

    return Container(
      width: 85.w,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey[50],
        border: Border(
          left: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey[200]!,
          ),
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: state.items.length + extraTrailing,
        itemBuilder: (context, index) {
          if (index >= state.items.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Center(
                child: SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: const CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                  ),
                ),
              ),
            );
          }

          final category = state.items[index];
          final isSelected = state.selectedCategoryId == category.id;

          return GestureDetector(
            onTap: () {
              ref
                  .read(catalogCategoriesProvider.notifier)
                  .selectCategory(category.id);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark
                        ? AppColors.primaryOrange.withValues(alpha: 0.1)
                        : Colors.white)
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
                      color: isSelected
                          ? AppColors.primaryOrange.withValues(alpha: 0.1)
                          : Colors.transparent,
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
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primaryOrange
                          : theme.hintColor,
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
