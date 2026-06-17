import 'package:erp/core/common_widget/app_empty_widget/app_empty_widget.dart';
import 'package:erp/core/common_widget/app_error_widget/app_error_widget.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/products/widgets/product_card.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/modules/webstore/cart/presentation/view_model/cart_view_model.dart';
import 'package:erp/core/common_widget/app_snack_bar/app_snack_bar.dart';

class CatalogProductsBody extends ConsumerWidget {
  final ProductsState productsState;
  final List<WebStoreProduct> products;
  final ScrollController scrollController;
  final ValueChanged<WebStoreProduct> onProductTap;
  final VoidCallback onRetry;

  const CatalogProductsBody({
    super.key,
    required this.productsState,
    required this.products,
    required this.scrollController,
    required this.onProductTap,
    required this.onRetry,
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
        onRetry: onRetry,
      );
    }

    if (products.isEmpty) {
      return AppEmptyWidget(
        message: LocaleKeys.webstore.home.no_search_results.tr(context: context),
        subtitle: LocaleKeys.webstore.home.no_filter_results.tr(context: context),
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
              childAspectRatio: 0.6,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () => onProductTap(product),
                onAddToCart: () async {
                  final auth = ref.read(authStateProvider);
                  if (auth.status != AuthStatus.authenticated) {
                    if (context.mounted) {
                      AppSnackBar.showError(
                        context,
                        LocaleKeys.common.unauthorized.tr(context: context),
                      );
                    }
                    return;
                  }
                  final added = await ref.read(cartProvider.notifier).addToCart(product);
                  if (added && context.mounted) {
                    AppSnackBar.showSuccess(
                      context,
                      LocaleKeys.webstore.orders.added_to_cart.tr(context: context),
                    );
                  }
                },
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
