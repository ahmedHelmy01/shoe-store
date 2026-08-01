import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/product_card_widget.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

enum ProductSheetType {
  search,
  filter,
}

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

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ),
          10.verticalSpace,
          if (isLoading && products.isEmpty)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          else if (products.isEmpty)
            Expanded(child: _buildEmptyState(context, widget.type))
          else
            Expanded(
              child: Column(
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
              ),
            ),
        ],
      ),
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
