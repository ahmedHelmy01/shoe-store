import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/common_widget/app_snack_bar/app_snack_bar.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/modules/webstore/home/data/models/store_offer_model.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/product_details/product_details_view.dart';
import 'package:erp/modules/webstore/cart/presentation/view_model/cart_view_model.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/offer_widgets/offer_models_helpers.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// OFFER PRODUCTS BOTTOM SHEET (Opened when clicking an offer with products)
// ═══════════════════════════════════════════════════════════════════════════════

class OfferProductsBottomSheet extends ConsumerWidget {
  final StoreOfferModel offer;

  const OfferProductsBottomSheet({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAr = context.locale.languageCode == 'ar';
    final offerTitle = isAr ? (offer.nameAr ?? offer.name) : offer.name;
    final offerDesc = isAr
        ? (offer.descriptionAr ?? offer.description ?? '')
        : (offer.description ?? '');

    final discountLabel = offer.discountType == 1
        ? 'خصم ${offer.discountValue.toStringAsFixed(0)}%'
        : 'خصم ${offer.discountValue.toStringAsFixed(0)} ج.م';

    return ScaffoldMessenger(
      // Sheet-local Scaffold + Messenger so snack bars (e.g. "Added to cart")
      // appear in FRONT of the sheet instead of behind it on the underlying
      // page scaffold.
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1B4B) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
          // ── Drag handle ───────────────────────────────────────────────
          12.verticalSpace,
          Container(
            width: 44.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
          16.verticalSpace,

          // ── Header Block ──────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF5722), Color(0xFFFF9800)],
                              ),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Text(
                              discountLabel,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          10.horizontalSpace,
                          Text(
                            '${offer.products.length} ${isAr ? "منتج بالعرض" : "Products"}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryWine,
                            ),
                          ),
                        ],
                      ),
                      8.verticalSpace,
                      Text(
                        offerTitle,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : AppColors.textMain,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (offerDesc.isNotEmpty) ...[
                        4.verticalSpace,
                        Text(
                          offerDesc,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.7)
                                : Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20.sp,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          14.verticalSpace,
          Divider(
            height: 1,
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.2),
          ),
          12.verticalSpace,

          // ── Product Grid ──────────────────────────────────────────────
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
              itemCount: offer.products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 220.h,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemBuilder: (context, index) {
                final product = offer.products[index];
                return buildNiceOneProductCard(
                  context,
                  ref,
                  product,
                  offer,
                  isDark,
                  theme,
                );
              },
            ),
          ),
        ],
      ),
    ),
  ),
);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED PRODUCT CARD
// ═══════════════════════════════════════════════════════════════════════════════

Widget buildNiceOneProductCard(
  BuildContext context,
  WidgetRef ref,
  StoreOfferProductModel product,
  StoreOfferModel offer,
  bool isDark,
  ThemeData theme,
) {
  final webProduct = toWebStoreProduct(context, product, offer);
  final isAr = context.locale.languageCode == 'ar';
  final String title =
      isAr ? (product.nameAr ?? product.name) : (product.nameEn ?? product.name);

  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailsView(product: webProduct),
        ),
      );
    },
    borderRadius: BorderRadius.circular(18.r),
    child: Container(
      width: 155.w,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppColors.primaryWine.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              height: 90.h,
              width: 90.w,
              child: (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                  ? AppImage(
                      imagePath: product.imageUrl!,
                      width: 90.w,
                      height: 90.h,
                      fit: BoxFit.contain,
                    )
                  : Center(
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 40.sp,
                        color: AppColors.primaryWine.withValues(alpha: 0.5),
                      ),
                    ),
            ),
          ),
          8.verticalSpace,

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textMain,
            ),
          ),
          6.verticalSpace,

          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (webProduct.oldPrice != null)
                    Text(
                      '${webProduct.oldPrice!.toStringAsFixed(0)} ج.م',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    '${webProduct.price.toStringAsFixed(0)} ج.م',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryWine,
                    ),
                  ),
                ],
              ),

              InkWell(
                onTap: () async {
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
                      await ref.read(cartProvider.notifier).addToCart(webProduct);
                  if (added && context.mounted) {
                    AppSnackBar.showSuccess(
                      context,
                      LocaleKeys.webstore.orders.added_to_cart.tr(context: context),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryWine,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryWine.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add_shopping_cart_rounded,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
