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
// WIDGET 4: All Remaining Offers (Indices 6 to End) - Placed after Most Ordered
// Features: Displays ALL remaining offers stacked vertically as full-width banner strips
// ═══════════════════════════════════════════════════════════════════════════════

class OfferSlot4StripWidget extends ConsumerWidget {
  const OfferSlot4StripWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersState = ref.watch(offersVmProvider);
    final activeOffers = offersState.offers.where((o) => o.isActive).toList();

    final remainingOffers = activeOffers.safeSublist(6);
    if (remainingOffers.isEmpty) return const SizedBox.shrink();

    final isAr = context.locale.languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: '🎁 ${isAr ? "المزيد من التخفيضات والعروض" : "More Offers & Deals"}',
        ),
        8.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: remainingOffers.map((offer) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildSingleStripCard(context, offer, isAr),
              );
            }).toList(),
          ),
        ),
        16.verticalSpace,
      ],
    );
  }

  Widget _buildSingleStripCard(
    BuildContext context,
    StoreOfferModel offer,
    bool isAr,
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
    );
  }
}
