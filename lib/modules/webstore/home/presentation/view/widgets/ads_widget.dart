import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/ads/ads_view_model.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/ads/ads_state.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/common_widget/app_section_header/app_section_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';

class AdsSection extends ConsumerWidget {
  const AdsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adsVmProvider);

    if (state is AdsInitial || state is AdsLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: AppShimmer.adsCarousel(),
      );
    }

    if (state is AdsSuccess) {
      final ads = state.data.items;
      if (ads == null || ads.isEmpty) {
        return const SizedBox.shrink(); 
      }

      return Column(
        children: [
          AppSectionHeader(
            title: '📢 ${context.locale.languageCode == "ar" ? "حملات إعلانية وترويجية" : "Featured Promotions"}',
          ),
          SizedBox(
            height: 180.h,
            child: PageView.builder(
              itemCount: ads.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final ad = ads[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: AppImage(
                      imagePath: ad.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
