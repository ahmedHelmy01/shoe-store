import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/common_widget/app_section_header/app_section_header.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';
import 'package:erp/core/common_widget/app_snack_bar/app_snack_bar.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/home/data/models/store_offer_model.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/offers_view_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/product_details/product_details_view.dart';
import 'package:erp/modules/webstore/cart/presentation/view_model/cart_view_model.dart';

class FlashSaleWidget extends ConsumerStatefulWidget {
  const FlashSaleWidget({super.key});

  @override
  ConsumerState<FlashSaleWidget> createState() => _FlashSaleWidgetState();
}

class _FlashSaleWidgetState extends ConsumerState<FlashSaleWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdownTimer();
  }

  void _startCountdownTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Duration _getRemainingTime(StoreOfferModel offer) {
    final now = DateTime.now();
    final target = offer.endDate ?? now.add(const Duration(hours: 24));
    final diff = target.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }

  WebStoreProduct _convertToWebStoreProduct(
    StoreOfferProductModel p,
    StoreOfferModel offer,
  ) {
    double calculatedPrice = p.customPrice ?? p.salePrice;
    if (p.customPrice == null && offer.discountValue > 0) {
      if (offer.discountType == 1) {
        calculatedPrice = p.salePrice * (1 - (offer.discountValue / 100));
      } else {
        calculatedPrice = (p.salePrice - offer.discountValue).clamp(0, double.infinity);
      }
    }

    final isAr = context.locale.languageCode == 'ar';
    return WebStoreProduct(
      id: p.id,
      name: isAr ? (p.nameAr ?? p.name) : (p.nameEn ?? p.name),
      price: calculatedPrice,
      oldPrice: p.salePrice > calculatedPrice ? p.salePrice : null,
      image: p.imageUrl,
      images: p.imageUrl != null ? [p.imageUrl!] : [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final offersState = ref.watch(offersVmProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (offersState.isLoading && offersState.offers.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: SizedBox(
          height: 180.h,
          child: AppShimmer.slider(),
        ),
      );
    }

    if (offersState.offers.isEmpty) {
      return const SizedBox.shrink();
    }

    // Filter active offers
    final activeOffers = offersState.offers.where((o) => o.isActive).toList();
    if (activeOffers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Section Header ──────────────────────────────
        AppSectionHeader(
          title: LocaleKeys.webstore.home.exclusive_offers.tr(context: context),
          onViewAllTap: () {
            AppNavigator.push(
              context,
              AppRouteNames.webstoreCatalogProducts,
              arguments: {
                'preset': 'offers',
                'category_title': LocaleKeys.webstore.home.exclusive_offers.tr(context: context),
              },
            );
          },
        ),
        10.verticalSpace,

        // ─── All Offers List (Vertical) ───────────────────
        ...activeOffers.map((offer) => _buildOfferSection(offer, isDark, theme)),
      ],
    );
  }

  Widget _buildOfferSection(StoreOfferModel offer, bool isDark, ThemeData theme) {
    final remainingTime = _getRemainingTime(offer);

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Offer Hero Banner ───────────────────────
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF0F172A),
                        const Color(0xFF1E293B),
                      ]
                    : [
                        const Color(0xFF1E1B4B),
                        const Color(0xFF312E81),
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withValues(alpha: 0.25),
                  blurRadius: 20,
                  spreadRadius: -2,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: AppColors.primaryOrange.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Stack(
                children: [
                  // Background Ambient Glow Orbs
                  Positioned(
                    top: -40.h,
                    right: -40.w,
                    child: Container(
                      width: 150.w,
                      height: 150.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryOrange.withValues(alpha: 0.2),
                      ),
                    ),
                  ),

                  // Offer Banner Content
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Row: Discount Badge + Live Countdown Timer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Neon Discount Pill
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF5722),
                                    Color(0xFFFF9800),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withValues(alpha: 0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Text('🔥', style: TextStyle(fontSize: 14)),
                                  4.horizontalSpace,
                                  Text(
                                    offer.discountType == 1
                                        ? 'خصم ${offer.discountValue.toStringAsFixed(0)}%'
                                        : 'خصم ${offer.discountValue.toStringAsFixed(0)} ج.م',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Live Cyber Countdown Clock
                            _buildLiveTimer(remainingTime),
                          ],
                        ),
                        14.verticalSpace,

                        // Offer Banner Main Info Row
                        Row(
                          children: [
                            if (offer.imageUrl != null && offer.imageUrl!.isNotEmpty) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: AppImage(
                                  imagePath: offer.imageUrl!,
                                  width: 80.w,
                                  height: 80.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              14.horizontalSpace,
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.locale.languageCode == 'ar'
                                        ? (offer.nameAr ?? offer.name)
                                        : offer.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  4.verticalSpace,
                                  Text(
                                    context.locale.languageCode == 'ar'
                                        ? (offer.descriptionAr ?? offer.description ?? '')
                                        : (offer.description ?? ''),
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 12.sp,
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
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
          
          // ─── Offer Products Horizontal Reel ───────────────
          if (offer.products.isNotEmpty) ...[
            12.verticalSpace,
            SizedBox(
              height: 220.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: offer.products.length,
                separatorBuilder: (context, index) => 12.horizontalSpace,
                itemBuilder: (context, index) {
                  final product = offer.products[index];
                  return _buildProductCard(context, ref, product, offer, isDark, theme);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLiveTimer(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, color: AppColors.primaryOrange, size: 14.sp),
          6.horizontalSpace,
          _timerChip(hours),
          _timerColon(),
          _timerChip(minutes),
          _timerColon(),
          _timerChip(seconds),
        ],
      ),
    );
  }

  Widget _timerChip(String val) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        val,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  Widget _timerColon() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Text(
        ':',
        style: TextStyle(
          color: AppColors.primaryOrange,
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    WidgetRef ref,
    StoreOfferProductModel product,
    StoreOfferModel offer,
    bool isDark,
    ThemeData theme,
  ) {
    final webProduct = _convertToWebStoreProduct(product, offer);
    final isAr = context.locale.languageCode == 'ar';
    final String title = isAr ? (product.nameAr ?? product.name) : (product.nameEn ?? product.name);

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
                : AppColors.primaryOrange.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Center(
              child: SizedBox(
                height: 90.h,
                width: 90.w,
                child: Stack(
                  children: [
                    if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                      AppImage(
                        imagePath: product.imageUrl!,
                        width: 90.w,
                        height: 90.h,
                        fit: BoxFit.contain,
                      )
                    else
                      Center(
                        child: Icon(
                          Icons.medical_services_outlined,
                          size: 40.sp,
                          color: AppColors.primaryOrange.withValues(alpha: 0.5),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            8.verticalSpace,

            // Title
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

            // Price section & Quick Add Button Row
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Original price (if discounted)
                    if (webProduct.oldPrice != null)
                      Text(
                        '${webProduct.oldPrice!.toStringAsFixed(0)} ج.م',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    // Discounted / Sale price
                    Text(
                      '${webProduct.price.toStringAsFixed(0)} ج.م',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),

                // Add to Cart Action Circle Button
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
                    final added = await ref.read(cartProvider.notifier).addToCart(webProduct);
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
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryOrange.withValues(alpha: 0.3),
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
}
