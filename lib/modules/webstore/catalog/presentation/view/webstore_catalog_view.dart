/// WebStore Catalog View (Vertical Slices)
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/product_card.dart';
import 'package:erp/core/common_widget/app_empty_widget/app_empty_widget.dart';

class WebStoreCatalogView extends ConsumerStatefulWidget {
  const WebStoreCatalogView({super.key});

  @override
  ConsumerState<WebStoreCatalogView> createState() => _WebStoreCatalogViewState();
}

class _WebStoreCatalogViewState extends ConsumerState<WebStoreCatalogView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _categoryScrollController = ScrollController();
  final ScrollController _productScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _categoryScrollController.addListener(_onCategoryScroll);
    _productScrollController.addListener(_onProductScroll);
  }

  void _onCategoryScroll() {
    if (_categoryScrollController.position.pixels >= _categoryScrollController.position.maxScrollExtent - 200) {
      ref.read(catalogCategoriesProvider.notifier).getCategories();
    }
  }

  void _onProductScroll() {
    if (_productScrollController.position.pixels >= _productScrollController.position.maxScrollExtent - 400) {
      ref.read(catalogProductsProvider.notifier).getProducts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _categoryScrollController.dispose();
    _productScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(catalogProductsProvider);
    final categoriesState = ref.watch(catalogCategoriesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 🔍 Custom Professional Header & Search
            _buildHeader(isDark, theme),

            Expanded(
              child: Row(
                children: [
                  // 🏷️ Side Category Navigation (Paginated)
                  _buildSideCategoryList(categoriesState, isDark, theme),

                  // 📦 Products Display (Paginated Grid)
                  Expanded(
                    child: _buildProductsArea(productsState, isDark, theme),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: 'بحث عن منتجات طبية...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
                  prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                ),
                onSubmitted: (value) {
                  ref.read(catalogProductsProvider.notifier).search(value);
                },
              ),
            ),
          ),
          12.horizontalSpace,
          _buildCircleAction(Icons.favorite_border_rounded, isDark, theme),
          8.horizontalSpace,
          _buildCircleAction(Icons.mail_outline_rounded, isDark, theme),
        ],
      ),
    );
  }

  Widget _buildCircleAction(IconData icon, bool isDark, ThemeData theme) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Icon(icon, size: 20.sp, color: isDark ? Colors.white70 : Colors.black87),
    );
  }

  Widget _buildSideCategoryList(CategoriesState state, bool isDark, ThemeData theme) {
    return Container(
      width: 85.w,
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.grey[50],
        border: Border(
          left: BorderSide(color: isDark ? Colors.white10 : Colors.grey[200]!, width: 1),
        ),
      ),
      child: state.isLoading 
          ? _buildCategoryShimmer()
          : ListView.builder(
              controller: _categoryScrollController,
              itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.items.length) {
                  return Padding(
                    padding: EdgeInsets.all(16.w),
                    child: const Center(child: CircularProgressIndicator.adaptive(strokeWidth: 2)),
                  );
                }

                final category = state.items[index];
                final isSelected = state.selectedCategoryId == category.id;

                return GestureDetector(
                  onTap: () => ref.read(catalogCategoriesProvider.notifier).selectCategory(category.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? (isDark ? theme.scaffoldBackgroundColor : Colors.white) 
                          : Colors.transparent,
                      border: isSelected 
                          ? Border(right: BorderSide(color: AppColors.primaryOrange, width: 4.w))
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(
                          category.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected 
                                ? AppColors.primaryOrange 
                                : (isDark ? Colors.white60 : Colors.black54),
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

  Widget _buildProductsArea(ProductsState state, bool isDark, ThemeData theme) {
    if (state.isLoading) {
      return _buildProductGridShimmer();
    }

    if (state.errorMessage != null) {
      return Center(child: Text(state.errorMessage!));
    }

    if (state.items.isEmpty) {
      return const AppEmptyWidget(
        message: 'لا توجد منتجات',
        subtitle: 'لم نجد أي منتجات في هذا القسم حالياً، جرب تصفح أقسام أخرى.',
      );
    }

    return CustomScrollView(
      controller: _productScrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(16.w),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Picks for you',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.sp),
                ),
                Text(
                  'أحدث المنتجات',
                  style: TextStyle(color: AppColors.primaryOrange, fontSize: 12.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ProductCard(product: state.items[index]);
              },
              childCount: state.items.length,
            ),
          ),
        ),
        if (state.isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.h),
              child: const Center(child: CircularProgressIndicator.adaptive()),
            ),
          ),
        SliverToBoxAdapter(child: 80.verticalSpace),
      ],
    );
  }

  Widget _buildCategoryShimmer() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (_, __) => Padding(
        padding: EdgeInsets.all(12.w),
        child: AppShimmer.box(width: 60.w, height: 40.h, borderRadius: 8.r),
      ),
    );
  }

  Widget _buildProductGridShimmer() {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: 6,
      itemBuilder: (_, index) => AppShimmer.productCard(),
    );
  }
}
