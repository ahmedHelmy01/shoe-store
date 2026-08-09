import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/product_card_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/product_list_tile.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

enum ProductSheetType {
  search,
  filter,
}

enum ProductViewMode { list, grid }

class ProductResultBottomSheet extends ConsumerStatefulWidget {
  final ProductSheetType type;

  const ProductResultBottomSheet({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ProductResultBottomSheet> createState() =>
      _ProductResultBottomSheetState();
}

class _ProductResultBottomSheetState
    extends ConsumerState<ProductResultBottomSheet> {
  final ScrollController _scrollController = ScrollController();

  // Default view mode: LIST
  ProductViewMode _viewMode = ProductViewMode.list;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.type == ProductSheetType.search) {
        ref.read(homeVmProvider.notifier).loadMoreSearch();
      }
    }
  }

  void _toggleViewMode() {
    setState(() {
      _viewMode = _viewMode == ProductViewMode.list
          ? ProductViewMode.grid
          : ProductViewMode.list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final homeState = ref.watch(homeVmProvider);

    final products = widget.type == ProductSheetType.search
        ? homeState.searchProducts
        : homeState.filteredProducts;

    final isLoading = widget.type == ProductSheetType.search
        ? homeState.isSearchLoading
        : homeState.isLoading;

    final isLoadingMore = widget.type == ProductSheetType.search
        ? homeState.isSearchLoadingMore
        : false;

    return ScaffoldMessenger(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
              color: isDark ? theme.scaffoldBackgroundColor : Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            padding: EdgeInsets.only(
              top: 20.h,
              left: 16.w,
              right: 16.w,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
            ),
            child: Column(
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.type == ProductSheetType.search
                          ? LocaleKeys.webstore.home.search_results.tr(context: context)
                          : LocaleKeys.webstore.home.filter_results.tr(context: context),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textColor,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Toggle view mode: LIST <-> GRID
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.grey[200])!
                                .withValues(alpha: isDark ? 0.6 : 0.7),
                          ),
                          child: IconButton(
                            iconSize: 20,
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            onPressed: _toggleViewMode,
                            tooltip: _viewMode == ProductViewMode.list
                                ? 'عرض شبكي'
                                : 'عرض قائمة',
                            icon: Icon(
                              _viewMode == ProductViewMode.list
                                  ? Icons.grid_view_rounded
                                  : Icons.view_list_rounded,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                        4.horizontalSpace,
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                10.verticalSpace,
                if (isLoading && products.isEmpty)
                  Expanded(
                    child: _viewMode == ProductViewMode.grid
                        ? _buildGridShimmer()
                        : _buildListShimmer(),
                  )
                else if (products.isEmpty)
                  Expanded(child: _buildEmptyState(context, widget.type))
                else
                  Expanded(
                    child: _buildResults(
                      products,
                      isLoadingMore,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResults(
    List products,
    bool isLoadingMore,
  ) {
    if (_viewMode == ProductViewMode.grid) {
      return Column(
        children: [
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 16.h),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 260.h,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemBuilder: (_, index) {
                return ProductGridCard(
                  product: products[index],
                );
              },
            ),
          ),
          if (isLoadingMore) ...[
            SizedBox(height: 8.h),
            const Center(child: CircularProgressIndicator.adaptive()),
            SizedBox(height: 8.h),
          ],
        ],
      );
    }

    // LIST mode (default): ListView.builder
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 16.h),
            itemCount: products.length,
            separatorBuilder: (_, index) => const Divider(height: 1),
            itemBuilder: (_, index) {
              return ProductListTile(
                product: products[index],
              );
            },
          ),
        ),
        if (isLoadingMore) ...[
          SizedBox(height: 8.h),
          const Center(child: CircularProgressIndicator.adaptive()),
          SizedBox(height: 8.h),
        ],
      ],
    );
  }

  Widget _buildListShimmer() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 16.h),
      itemCount: 8,
      separatorBuilder: (_, index) => const Divider(height: 1),
      itemBuilder: (_, index) {
        return AppShimmer(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
            child: Row(
              children: [
                // Image placeholder
                Container(
                  width: 70.w,
                  height: 70.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                10.horizontalSpace,
                // Text placeholders
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      6.verticalSpace,
                      Container(
                        width: 60.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      8.verticalSpace,
                      Container(
                        width: 50.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
                // Icon placeholders
                Column(
                  children: [
                    Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    4.verticalSpace,
                    Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridShimmer() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 16.h),
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 260.h,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemBuilder: (_, index) {
        return AppShimmer(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                Expanded(
                  flex: 6,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    ),
                  ),
                ),
                // Info placeholder
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 10.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            4.verticalSpace,
                            Container(
                              width: 50.w,
                              height: 8.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 40.w,
                              height: 12.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            Container(
                              width: 28.w,
                              height: 28.w,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, ProductSheetType type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64.sp, color: Colors.grey[400]),
          16.verticalSpace,
          Text(
            type == ProductSheetType.search
                ? LocaleKeys.webstore.home.no_search_results.tr(context: context)
                : LocaleKeys.webstore.home.no_filter_results.tr(context: context),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
