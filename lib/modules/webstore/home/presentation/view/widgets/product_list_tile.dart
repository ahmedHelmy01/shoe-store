import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/common_widget/app_price_text/app_price_text.dart';
import 'package:erp/core/common_widget/app_snack_bar/app_snack_bar.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/product_details/product_details_view.dart';
import 'package:erp/modules/webstore/wishlist/presentation/view_model/wishlist_providers.dart';
import 'package:erp/modules/webstore/cart/presentation/view_model/cart_view_model.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductListTile extends ConsumerWidget {
  final WebStoreProduct product;

  const ProductListTile({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bool hasDiscount = product.oldPrice != null &&
        product.oldPrice! > product.price;

    final wishlist = ref.watch(wishlistProvider).value ?? [];
    final isWishlisted =
        product.id != null && wishlist.any((p) => p.id == product.id);
    final isLoggedIn =
        ref.watch(authStateProvider).status == AuthStatus.authenticated;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsView(product: product),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            SizedBox(
              width: 70.w,
              height: 70.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: AppImage(
                  imagePath: product.image ?? '',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            10.horizontalSpace,
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color,
                      height: 1.2,
                    ),
                  ),
                  if (product.brand != null)
                    Padding(
                      padding: EdgeInsets.only(top: 1.h),
                      child: Text(
                        product.brand!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.5)
                              : theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  2.verticalSpace,
                  Row(
                    children: [
                      AppPriceText(
                        price: product.price,
                        oldPrice: product.oldPrice,
                      ),
                      if (hasDiscount && product.oldPrice != null)
                        Container(
                          margin: EdgeInsetsDirectional.only(start: 6.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryWine,
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                          child: Text(
                            '${(((product.oldPrice! - product.price) / product.oldPrice!) * 100).toInt()}%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Add to cart + Wishlist
            Column(
              children: [
                if (isLoggedIn)
                  SizedBox(
                    width: 30.w,
                    height: 30.w,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 16,
                      onPressed: () {
                        if (product.id != null) {
                          ref.read(wishlistProvider.notifier).toggleWishlist(product);
                        }
                      },
                      icon: Icon(
                        isWishlisted
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_rounded,
                        color: isWishlisted ? Colors.red : Colors.grey.shade400,
                      ),
                    ),
                  ),
                SizedBox(
                  width: 30.w,
                  height: 30.w,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 16,
                    onPressed: () async {
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
                      final added =
                          await ref.read(cartProvider.notifier).addToCart(product);
                      if (added && context.mounted) {
                        AppSnackBar.showSuccess(
                          context,
                          LocaleKeys.webstore.orders.added_to_cart.tr(context: context),
                        );
                      }
                    },
                    icon: const Icon(Icons.add_shopping_cart,
                        color: AppColors.primaryWine, size: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
