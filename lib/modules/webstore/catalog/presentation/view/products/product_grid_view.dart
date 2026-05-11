import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/products/widgets/product_card.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/product_details/product_details_view.dart';
import 'package:erp/core/common_widget/app_empty_widget/app_empty_widget.dart';

class ProductGridView extends ConsumerWidget {
  final ScrollController scrollController;

  const ProductGridView({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(catalogProductsProvider);

    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
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
      controller: scrollController,
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
                final product = state.items[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsView(product: product),
                      ),
                    );
                  },
                );
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
}
