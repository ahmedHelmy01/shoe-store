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
        width: 95.w,
        color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey[50],
        child: const Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final extraTrailing = state.isLoadingMore ? 1 : 0;

    return Container(
      width: 95.w,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey[50],
        border: BorderDirectional(
          end: BorderSide(
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
          final isParentActive = state.selectedCategoryId == category.id ||
              category.children.any((child) => child.id == state.selectedCategoryId);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  final targetId = category.children.isNotEmpty
                      ? category.children.first.id
                      : category.id;
                  ref
                      .read(catalogCategoriesProvider.notifier)
                      .selectCategory(targetId);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: isParentActive
                        ? (isDark
                            ? AppColors.primaryOrange.withValues(alpha: 0.1)
                            : Colors.white)
                        : Colors.transparent,
                    border: BorderDirectional(
                      start: BorderSide(
                        color: isParentActive ? AppColors.primaryOrange : Colors.transparent,
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
                          color: isParentActive
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
                              isParentActive ? FontWeight.bold : FontWeight.w500,
                          color: isParentActive
                              ? AppColors.primaryOrange
                              : theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Tree structure subcategories under active parent
              if (isParentActive && category.children.isNotEmpty)
                Container(
                  color: isDark ? Colors.white.withValues(alpha: 0.01) : Colors.grey[50],
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Column(
                    children: category.children.map((child) {
                      final isChildSelected = state.selectedCategoryId == child.id;
                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(catalogCategoriesProvider.notifier)
                              .selectCategory(child.id);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                          margin: EdgeInsets.symmetric(vertical: 2.h),
                          decoration: BoxDecoration(
                            border: BorderDirectional(
                              start: BorderSide(
                                color: isChildSelected ? AppColors.primaryOrange : Colors.transparent,
                                width: 2.w,
                              ),
                            ),
                          ),
                          child: Text(
                            child.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9.sp,
                              height: 1.2,
                              fontWeight: isChildSelected ? FontWeight.bold : FontWeight.normal,
                              color: isChildSelected
                                  ? AppColors.primaryOrange
                                  : (isDark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
