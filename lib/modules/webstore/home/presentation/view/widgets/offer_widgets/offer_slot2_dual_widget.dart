import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/modules/webstore/home/data/models/store_offer_model.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/offers_view_model.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/offer_widgets/offer_models_helpers.dart';

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
                  child: buildDualCard(
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
}

Widget buildDualCard({
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
        ? () => showOfferProductsBottomSheet(context, offer)
        : null,
    child: Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1B4B) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : AppColors.primaryWine.withValues(alpha: 0.2),
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
                            color: AppColors.primaryWine
                                .withValues(alpha: 0.4),
                          ),
                        ),
                ),
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
                            color: AppColors.primaryWine,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 11.sp,
                          color: AppColors.primaryWine,
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
