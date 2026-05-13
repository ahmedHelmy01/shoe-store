import 'package:erp/core/common_widget/app_empty_widget/app_empty_widget.dart';
import 'package:erp/core/common_widget/app_error_widget/app_error_widget.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/products/widgets/product_card.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_state.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CatalogProductsBody extends ConsumerWidget {
  final ProductsState productsState;
  final List<WebStoreProduct> products;
  final ScrollController scrollController;
  final ValueChanged<WebStoreProduct> onProductTap;

  const CatalogProductsBody({
    super.key,
    required this.productsState,
    required this.products,
    required this.scrollController,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (productsState.isLoading && products.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (productsState.errorMessage != null && products.isEmpty) {
      return AppErrorWidget(
        errorMessage: productsState.errorMessage,
        onRetry: () {
          ref.read(catalogProductsProvider.notifier).getProducts(isRefresh: true);
        },
      );
    }

    if (products.isEmpty) {
      return const AppEmptyWidget(
        message: 'لا توجد منتجات مطابقة',
        subtitle: 'جرب تعديل الفلاتر أو إزالة بعض الشروط لعرض نتائج أكثر.',
      );
    }

    return CustomScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          sliver: SliverToBoxAdapter(
            child: Text(
              '${products.length} منتج',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
                fontWeight: FontWeight.w600,
              ),
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
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () => onProductTap(product),
              );
            }, childCount: products.length),
          ),
        ),
        if (productsState.isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(18.h),
              child: const Center(child: CircularProgressIndicator.adaptive()),
            ),
          ),
        SliverToBoxAdapter(child: 70.verticalSpace),
      ],
    );
  }
}
