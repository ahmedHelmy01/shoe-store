import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/common_widget/app_section_header/app_section_header.dart';
import 'package:erp/modules/webstore/home/data/models/store_offer_model.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/offers_view_model.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/offer_widgets/offer_models_helpers.dart';

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
              return buildReelCard(context, offer, isAr, isDark, theme);
            },
          ),
        ),
        16.verticalSpace,
      ],
    );
  }
}

Widget buildReelCard(
  BuildContext context,
  StoreOfferModel offer,
  bool isAr,
  bool isDark,
  ThemeData theme,
) {
  final title = isAr ? (offer.nameAr ?? offer.name) : offer.name;
  final discountLabel = offer.discountType == 1
      ? 'خصم ${offer.discountValue.toStringAsFixed(0)}%'
      : 'خصم ${offer.discountValue.toStringAsFixed(0)} ج.م';
  final bool hasProducts = offer.products.isNotEmpty;

  return GestureDetector(
    onTap: hasProducts
        ? () => showOfferProductsBottomSheet(context, offer)
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
          color: AppColors.primaryWine.withValues(alpha: 0.15),
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
                        color: AppColors.primaryWine,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
}
