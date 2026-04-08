import 'package:erp/modules/webstore/home/presentation/view_model/ads/ads_state.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/ads/ads_view_model.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/common_model/content_management_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_section_header/app_section_header.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/app_empty_widget/app_empty_widget.dart';

class AdsSection extends ConsumerStatefulWidget {
  const AdsSection({super.key});

  @override
  ConsumerState<AdsSection> createState() => _AdsSectionState();
}

class _AdsSectionState extends ConsumerState<AdsSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adsVmProvider.notifier).getAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ads = ref.watch(adsVmProvider);

    return switch (ads) {
      AdsLoading() => _buildLoadingShimmer(),
      AdsError(:final message) => Center(child: Text(message)),
      AdsSuccess(:final data) => _buildAdsList(data),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildLoadingShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: List.generate(
          2,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: AppShimmer.box(height: 120.h, borderRadius: 12.r),
          ),
        ),
      ),
    );
  }

  Widget _buildAdsList(ContentManagementModel data) {
    final items = data.items ?? [];

    if (items.isEmpty) {
      return AppEmptyWidget(
        message: LocaleKeys.webstore.home.no_exclusive_offers.tr(context: context),
        subtitle: LocaleKeys.webstore.home.no_exclusive_offers_subtitle.tr(context: context),
        showGlassBackground: false,
      );
    }

    return AppAnimation.fadeInUp(
      child: Column(
        children: [
          AppSectionHeader(title: LocaleKeys.webstore.home.exclusive_offers.tr(context: context)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: List.generate(
                items.length,
                (index) {
                  final item = items[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Stack(
                        children: [
                          /// BACKGROUND IMAGE
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: AppImage(
                              imagePath: item.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 120.h,
                            ),
                          ),

                          /// OVERLAY LAYER
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.black.withOpacity(0.8),
                                    Colors.black.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /// HTML CONTENT
                          Positioned.fill(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 15.h),
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Html(
                                  data: item.content.toString(),
                                  style: {
                                    "body": Style(
                                      color: Colors.white,
                                      fontSize: FontSize(16.sp),
                                      fontWeight: FontWeight.bold,
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                    ),
                                    "p": Style(
                                      color: Colors.white,
                                      margin: Margins.zero,
                                    ),
                                    "span": Style(
                                      color: AppColors.primaryOrange,
                                    )
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
