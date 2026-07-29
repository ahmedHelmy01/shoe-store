import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/common_widget/app_section_header/app_section_header.dart';
import 'package:erp/core/common_widget/app_snack_bar/app_snack_bar.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/modules/webstore/home/data/models/store_offer_model.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/offers_view_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/product_details/product_details_view.dart';
import 'package:erp/modules/webstore/cart/presentation/view_model/cart_view_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// NiceOne-Inspired Dynamic Distributed Offers System
//
// Offers are safely partitioned into 4 distinct widgets across the Home Screen:
//   1. OfferSlot1HeroWidget   -> Placed after "أقسام الصيدلية" (Index 0 - ONLY ONE WITH TIMER)
//   2. OfferSlot2DualWidget   -> Placed after "جميع الخدمات"     (Indices 1, 2 - Luxury 2-Column Cards)
//   3. OfferSlot3ReelWidget   -> Placed after "الكوبونات"       (Indices 3, 4, 5 - Featured Deals Reel)
//   4. OfferSlot4StripWidget  -> Placed after "الأكثر طلباً"    (Indices 6..N - ALL REMAINING OFFERS!)
//
// Interactive Behavior:
//   • If an offer HAS products (offer.products.isNotEmpty):
//       Tapping the offer opens a BottomSheet displaying the offer's products!
//   • If an offer HAS NO products (offer.products.isEmpty):
//       The offer is NOT clickable (static promo banner).
// ─────────────────────────────────────────────────────────────────────────────

extension _SafeSlice<T> on List<T> {
  List<T> safeSublist(int start, [int? end]) {
    if (start >= length) return [];
    final realEnd = (end == null || end > length) ? length : end;
    return sublist(start, realEnd);
  }
}

WebStoreProduct _toWebStoreProduct(
  BuildContext context,
  StoreOfferProductModel p,
  StoreOfferModel offer,
) {
  double calculatedPrice = p.customPrice ?? p.salePrice;
  if (p.customPrice == null && offer.discountValue > 0) {
    if (offer.discountType == 1) {
      calculatedPrice = p.salePrice * (1 - (offer.discountValue / 100));
    } else {
      calculatedPrice =
          (p.salePrice - offer.discountValue).clamp(0, double.infinity);
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

/// Opens the BottomSheet displaying the offer's products
void _showOfferProductsBottomSheet(BuildContext context, StoreOfferModel offer) {
  if (offer.products.isEmpty) return;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => OfferProductsBottomSheet(offer: offer),
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// WIDGET 1: Hero Offer (Index 0) - Placed after Pharmacy Sections
// Features: Ticking Timer, NiceOne Hero Banner & Horizontal Product Slider
// ═══════════════════════════════════════════════════════════════════════════════

class OfferSlot1HeroWidget extends ConsumerStatefulWidget {
  const OfferSlot1HeroWidget({super.key});

  @override
  ConsumerState<OfferSlot1HeroWidget> createState() =>
      _OfferSlot1HeroWidgetState();
}

class _OfferSlot1HeroWidgetState extends ConsumerState<OfferSlot1HeroWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
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

  @override
  Widget build(BuildContext context) {
    final offersState = ref.watch(offersVmProvider);
    final activeOffers = offersState.offers.where((o) => o.isActive).toList();

    if (activeOffers.isEmpty) return const SizedBox.shrink();

    final heroOffer = activeOffers.first;
    final remainingTime = _getRemainingTime(heroOffer);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAr = context.locale.languageCode == 'ar';

    final offerTitle = isAr ? (heroOffer.nameAr ?? heroOffer.name) : heroOffer.name;
    final offerDesc = isAr
        ? (heroOffer.descriptionAr ?? heroOffer.description ?? '')
        : (heroOffer.description ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: '🔥 ${LocaleKeys.webstore.home.exclusive_offers.tr(context: context)}',
          onViewAllTap: () {
            AppNavigator.push(
              context,
              AppRouteNames.webstoreCatalogProducts,
              arguments: {'preset': 'offers'},
            );
          },
        ),
        8.verticalSpace,

        // NiceOne Hero Card
        GestureDetector(
          onTap: heroOffer.products.isNotEmpty
              ? () => _showOfferProductsBottomSheet(context, heroOffer)
              : null,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E1B4B),
                  Color(0xFF312E81),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Stack(
                children: [
                  if (heroOffer.imageUrl != null && heroOffer.imageUrl!.isNotEmpty)
                    Positioned.fill(
                      child: AppImage(
                        imagePath: heroOffer.imageUrl!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.4),
                            Colors.black.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF5722), Color(0xFFFF9800)],
                                ),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Text(
                                heroOffer.discountType == 1
                                    ? 'خصم ${heroOffer.discountValue.toStringAsFixed(0)}%'
                                    : 'خصم ${heroOffer.discountValue.toStringAsFixed(0)} ج.م',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            _buildLiveTimer(remainingTime),
                          ],
                        ),
                        16.verticalSpace,

                        Text(
                          offerTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (offerDesc.isNotEmpty) ...[
                          4.verticalSpace,
                          Text(
                            offerDesc,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12.sp,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Product Reel
        if (heroOffer.products.isNotEmpty) ...[
          12.verticalSpace,
          SizedBox(
            height: 215.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: heroOffer.products.length,
              separatorBuilder: (_, _) => 12.horizontalSpace,
              itemBuilder: (context, index) {
                final product = heroOffer.products[index];
                return _buildNiceOneProductCard(
                  context,
                  ref,
                  product,
                  heroOffer,
                  isDark,
                  theme,
                );
              },
            ),
          ),
        ],
        16.verticalSpace,
      ],
    );
  }

  Widget _buildLiveTimer(Duration duration) {
    String pad(int n) => n.toString().padLeft(2, '0');
    final hours = pad(duration.inHours);
    final minutes = pad(duration.inMinutes.remainder(60));
    final seconds = pad(duration.inSeconds.remainder(60));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.primaryOrange.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined,
              color: AppColors.primaryOrange, size: 14.sp),
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

  Widget _timerChip(String val) => Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
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

  Widget _timerColon() => Padding(
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

// ═══════════════════════════════════════════════════════════════════════════════
// WIDGET 2: Dual Luxury Promo Cards (Indices 1, 2) - Placed after Services
// Features: High-End Dual Cards with generous 14.w spacing & BottomSheet Trigger
// ═══════════════════════════════════════════════════════════════════════════════

class OfferSlot2DualWidget extends ConsumerWidget {
  const OfferSlot2DualWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersState = ref.watch(offersVmProvider);
    final activeOffers = offersState.offers.where((o) => o.isActive).toList();

    final dualOffers = activeOffers.safeSublist(1, 3);
    if (dualOffers.isEmpty) return const SizedBox.shrink();

    final isAr = context.locale.languageCode == 'ar';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < dualOffers.length; i++) ...[
                if (i > 0) 14.horizontalSpace,
                Expanded(
                  child: _buildDualCard(
                    context: context,
                    offer: dualOffers[i],
                    isAr: isAr,
                    isDark: isDark,
                  ),
                ),
              ],
            ],
          ),
        ),
        16.verticalSpace,
      ],
    );
  }

  Widget _buildDualCard({
    required BuildContext context,
    required StoreOfferModel offer,
    required bool isAr,
    required bool isDark,
  }) {
    final title = isAr ? (offer.nameAr ?? offer.name) : offer.name;
    final discountLabel = offer.discountType == 1
        ? 'خصم ${offer.discountValue.toStringAsFixed(0)}%'
        : 'خصم ${offer.discountValue.toStringAsFixed(0)} ج.م';

    final hasOfferImg = (offer.imageUrl ?? '').isNotEmpty;
    final productImg = (offer.products.isNotEmpty &&
            (offer.products.first.imageUrl ?? '').isNotEmpty)
        ? offer.products.first.imageUrl
        : null;
    final displayImg = hasOfferImg ? offer.imageUrl : productImg;
    final bool hasProducts = offer.products.isNotEmpty;

    return GestureDetector(
      onTap: hasProducts
          ? () => _showOfferProductsBottomSheet(context, offer)
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1B4B) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : AppColors.primaryOrange.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.07),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Top Image Container with Floating Badge ──────
              Stack(
                children: [
                  Container(
                    height: 100.h,
                    width: double.infinity,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : const Color(0xFFF8FAFC),
                    child: displayImg != null
                        ? AppImage(
                            imagePath: displayImg,
                            width: double.infinity,
                            height: 100.h,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Icon(
                              Icons.local_offer_outlined,
                              size: 40.sp,
                              color: AppColors.primaryOrange
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                  ),

                  // Floating Discount Badge
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF5722),
                            Color(0xFFFF9800)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        discountLabel,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ── Bottom Content Block ─────────────────────────
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : AppColors.textMain,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    8.verticalSpace,
                    if (hasProducts)
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isAr ? 'عرض المنتجات' : 'View Products',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryOrange,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 11.sp,
                            color: AppColors.primaryOrange,
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

// ═══════════════════════════════════════════════════════════════════════════════
// WIDGET 3: Horizontal Offer Reel (Indices 3, 4, 5) - Placed after Vouchers
// Features: NiceOne Banner Slider Carousel (NO TIMER)
// ═══════════════════════════════════════════════════════════════════════════════

class OfferSlot3ReelWidget extends ConsumerWidget {
  const OfferSlot3ReelWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersState = ref.watch(offersVmProvider);
    final activeOffers = offersState.offers.where((o) => o.isActive).toList();

    final reelOffers = activeOffers.safeSublist(3, 6);
    if (reelOffers.isEmpty) return const SizedBox.shrink();

    final isAr = context.locale.languageCode == 'ar';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: '⭐ ${isAr ? "عروض مختارة لك" : "Featured Deals"}',
          onViewAllTap: () {
            AppNavigator.push(
              context,
              AppRouteNames.webstoreCatalogProducts,
              arguments: {'preset': 'offers'},
            );
          },
        ),
        8.verticalSpace,
        SizedBox(
          height: 160.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: reelOffers.length,
            separatorBuilder: (_, _) => 12.horizontalSpace,
            itemBuilder: (context, index) {
              final offer = reelOffers[index];
              final title = isAr ? (offer.nameAr ?? offer.name) : offer.name;
              final discountLabel = offer.discountType == 1
                  ? 'خصم ${offer.discountValue.toStringAsFixed(0)}%'
                  : 'خصم ${offer.discountValue.toStringAsFixed(0)} ج.م';
              final bool hasProducts = offer.products.isNotEmpty;

              return GestureDetector(
                onTap: hasProducts
                    ? () => _showOfferProductsBottomSheet(context, offer)
                    : null,
                child: Container(
                  width: 260.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: isDark ? theme.cardColor : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.primaryOrange.withValues(alpha: 0.15),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Stack(
                      children: [
                        if (offer.imageUrl != null && offer.imageUrl!.isNotEmpty)
                          Positioned.fill(
                            child: AppImage(
                              imagePath: offer.imageUrl!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.8),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryOrange,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Text(
                                    discountLabel,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (hasProducts) ...[
                                    8.horizontalSpace,
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white,
                                      size: 14.sp,
                                    ),
                                  ],
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
            },
          ),
        ),
        16.verticalSpace,
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// WIDGET 4: All Remaining Offers (Indices 6 to End) - Placed after Most Ordered
// Features: Displays ALL remaining offers with BottomSheet trigger when products exist
// ═══════════════════════════════════════════════════════════════════════════════

class OfferSlot4StripWidget extends ConsumerWidget {
  const OfferSlot4StripWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersState = ref.watch(offersVmProvider);
    final activeOffers = offersState.offers.where((o) => o.isActive).toList();

    final stripOffers = activeOffers.safeSublist(6);
    if (stripOffers.isEmpty) return const SizedBox.shrink();

    final isAr = context.locale.languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: '🎁 ${isAr ? "المزيد من التخفيضات" : "More Offers"}',
          onViewAllTap: () {
            AppNavigator.push(
              context,
              AppRouteNames.webstoreCatalogProducts,
              arguments: {'preset': 'offers'},
            );
          },
        ),
        8.verticalSpace,

        ...stripOffers.map((offer) {
          final title = isAr ? (offer.nameAr ?? offer.name) : offer.name;
          final discountLabel = offer.discountType == 1
              ? 'خصم ${offer.discountValue.toStringAsFixed(0)}%'
              : 'خصم ${offer.discountValue.toStringAsFixed(0)} ج.م';
          final bool hasProducts = offer.products.isNotEmpty;

          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: GestureDetector(
              onTap: hasProducts
                  ? () => _showOfferProductsBottomSheet(context, offer)
                  : null,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                height: 85.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.r),
                  child: Stack(
                    children: [
                      if (offer.imageUrl != null && offer.imageUrl!.isNotEmpty)
                        Positioned.fill(
                          child: AppImage(
                            imagePath: offer.imageUrl!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.45),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  4.verticalSpace,
                                  Text(
                                    discountLabel,
                                    style: TextStyle(
                                      color: AppColors.primaryOrange,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (hasProducts)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 7.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  isAr ? 'عرض المنتجات' : 'View Products',
                                  style: TextStyle(
                                    color: AppColors.primaryOrange,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        16.verticalSpace,
      ],
    );
  }
}

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

    return Container(
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
      child: Column(
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
                              color: AppColors.primaryOrange,
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
                return _buildNiceOneProductCard(
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
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED PRODUCT CARD (Used inside Hero Offer Reel & Offer BottomSheet)
// ═══════════════════════════════════════════════════════════════════════════════

Widget _buildNiceOneProductCard(
  BuildContext context,
  WidgetRef ref,
  StoreOfferProductModel product,
  StoreOfferModel offer,
  bool isDark,
  ThemeData theme,
) {
  final webProduct = _toWebStoreProduct(context, product, offer);
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
              : AppColors.primaryOrange.withValues(alpha: 0.08),
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
                        Icons.medical_services_outlined,
                        size: 40.sp,
                        color: AppColors.primaryOrange.withValues(alpha: 0.5),
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
                      color: AppColors.primaryOrange,
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
