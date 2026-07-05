/// WebStore Product Card Widget (Catalog Slice)
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/wishlist/presentation/view_model/wishlist_providers.dart';
import 'package:shimmer/shimmer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/app_snack_bar/app_snack_bar.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/cart/presentation/view_model/cart_view_model.dart';

class ProductCard extends ConsumerWidget {
  final WebStoreProduct product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onToggleWishlist;
  final bool? isWishlisted;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.onToggleWishlist,
    this.isWishlisted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider).value ?? [];
    final auth = ref.watch(authStateProvider);
    final isLoggedIn = auth.status == AuthStatus.authenticated;
    final product = this.product;
    final effectiveIsWishlisted = isWishlisted ??
        (product.id != null && wishlist.any((p) => p.id == product.id));
    final effectiveOnToggleWishlist = onToggleWishlist ??
        () {
          if (product.id != null) {
            ref.read(wishlistProvider.notifier).toggleWishlist(product);
          }
        };
    final effectiveOnAddToCart = onAddToCart ??
        () async {
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
        };
    final currency = AppConstants.currency;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SizedBox(
          height: 230,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Image ───────────────────────────────────────
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Container(
                        color: Theme.of(context).hintColor.withValues(alpha: 0.05),
                        padding: const EdgeInsets.all(6),
                        child: Image.network(
                          product.image ?? '',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade200,
                              highlightColor: Colors.grey.shade100,
                              child: Container(color: Colors.white),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (product.hasDiscount)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${product.discountPercent.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    if (isLoggedIn)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: IconButton(
                          onPressed: effectiveOnToggleWishlist,
                          icon: Icon(
                            effectiveIsWishlisted
                                ? Icons.favorite_rounded
                                : Icons.favorite_outline_rounded,
                            color: effectiveIsWishlisted ? Colors.red : Colors.grey.shade400,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ─── Product Info ────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.brand ?? product.category?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    if (product.hasDiscount)
                      Text(
                        '$currency ${product.oldPrice}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Theme.of(context).hintColor,
                          fontSize: 11,
                        ),
                      ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$currency ${product.price}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.primaryOrange,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: IconButton.filled(
                            onPressed: effectiveOnAddToCart,
                            iconSize: 14,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints.tightFor(
                              width: 28,
                              height: 28,
                            ),
                            style: IconButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: AppColors.primaryOrange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.add_shopping_cart_rounded),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
