import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_horizontal_loader/app_horizontal_loader.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/catalog/data/models/category_model.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

class CategorySection extends ConsumerStatefulWidget {
  const CategorySection({super.key});

  @override
  ConsumerState<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends ConsumerState<CategorySection> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onHorizontalScroll);
  }

  void _onHorizontalScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (!pos.hasContentDimensions || pos.maxScrollExtent <= 0) return;
    if (pos.pixels < pos.maxScrollExtent - 56) return;

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

    if (state.isLoading && state.items.isEmpty) {
      return AppHorizontalLoader(
        height: 90.h,
        itemWidth: 70.w,
        borderRadius: 35,
      );
    }

    if (state.errorMessage != null && state.items.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.common.unexpected_error.tr(context: context),
              style: TextStyle(
                fontSize: 12.sp,
                color: theme.hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(catalogCategoriesProvider.notifier).getCategories(isRefresh: true);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                LocaleKeys.common.retry.tr(context: context),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryOrange,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppAnimation.fadeInUp(
      child: SizedBox(
        height: 120.h,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < state.items.length) {
              return _CategoryItem(cat: state.items[index]);
            }
            
            return Padding(
              padding: EdgeInsetsDirectional.only(start: 12.w),
              child: SizedBox(
                width: 42.w,
                height: 90.h,
                child: Center(
                  child: SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: const CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final WebStoreCategory cat;
  const _CategoryItem({required this.cat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color categoryColor = AppColors.primaryOrange;

    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: InkWell(
        onTap: cat.id == null
            ? null
            : () {
                final targetId =
                    cat.children.isNotEmpty ? cat.children.first.id : cat.id;
                final targetTitle = cat.children.isNotEmpty
                    ? cat.children.first.name
                    : cat.name;

                AppNavigator.push(
                  context,
                  AppRouteNames.webstoreCatalogProducts,
                  arguments: {
                    'category_id': targetId,
                    'category_title': targetTitle,
                  },
                );
              },
        borderRadius: BorderRadius.circular(40.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    categoryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                    categoryColor.withValues(alpha: isDark ? 0.05 : 0.02),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: categoryColor.withValues(alpha: isDark ? 0.1 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color:
                      categoryColor.withValues(alpha: isDark ? 0.3 : 0.15),
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: cat.image != null && cat.image!.isNotEmpty
                    ? AppImage(
                        imagePath: cat.image!,
                        width: 40.w,
                        height: 40.w,
                        fit: BoxFit.contain,
                        memCacheWidth: 150,
                        memCacheHeight: 150,
                      )
                    : Center(
                        child: Icon(
                          Icons.category_outlined,
                          color: categoryColor,
                          size: 30.sp,
                        ),
                      ),
              ),
            ),
            8.verticalSpace,
            SizedBox(
              width: 80.w,
              child: Text(
                cat.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.9)
                      : theme.textTheme.bodyMedium?.color
                          ?.withValues(alpha: 0.8),
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
