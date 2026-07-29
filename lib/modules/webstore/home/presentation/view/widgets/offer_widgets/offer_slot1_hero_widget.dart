import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/common_widget/app_section_header/app_section_header.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/modules/webstore/home/data/models/store_offer_model.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/offers_view_model.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/offer_widgets/offer_models_helpers.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/offer_widgets/offer_products_bottom_sheet.dart';

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
        ),
        8.verticalSpace,

        // NiceOne Hero Card
        GestureDetector(
          onTap: heroOffer.products.isNotEmpty
              ? () => showOfferProductsBottomSheet(context, heroOffer)
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
            height: 238.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 14.h),
              itemCount: heroOffer.products.length,
              separatorBuilder: (_, _) => 12.horizontalSpace,
              itemBuilder: (context, index) {
                final product = heroOffer.products[index];
                return buildNiceOneProductCard(
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
