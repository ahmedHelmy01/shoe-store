import 'package:erp/modules/webstore/points/presentation/view_model/points_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/unified_header_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/loyalty_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/vouchers_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/feature_links_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/ads_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/product_grid_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/company_produce_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/slider_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/dynamic_offers_section.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/home_categories_row.dart';
import 'package:erp/core/common_widget/app_section_header/app_section_header.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/ads/ads_view_model.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';
import 'package:erp/core/router/app_navigator.dart';

class WebStoreHomeScreen extends ConsumerStatefulWidget {
  const WebStoreHomeScreen({super.key});

  @override
  ConsumerState<WebStoreHomeScreen> createState() => _WebStoreHomeScreenState();
}

class _WebStoreHomeScreenState extends ConsumerState<WebStoreHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _refreshHomeData() async {
    // Simply invalidate all home-related providers. 
    // They will automatically re-fetch data upon rebuild due to our build() microtask logic.
    ref.invalidate(homeVmProvider);
    ref.invalidate(adsVmProvider);
    ref.invalidate(sliderVmProvider);
    ref.invalidate(companyProducesVmProvider);
    ref.invalidate(offersVmProvider);
    ref.invalidate(branchVmProvider);
    ref.invalidate(pointsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLoading = ref.watch(homeVmProvider.select((s) => s.isLoading));

    return WebStoreBaseScaffold(
      scaffoldKey: _scaffoldKey,
      showAppBar: false, // Unified header handles the top area
      body: RefreshIndicator(
        onRefresh: _refreshHomeData,
        backgroundColor: theme.cardColor,
        color: AppColors.primaryOrange,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollStartNotification) {
              ref.read(homeScrollProvider.notifier).setScrolling(true);
            } else if (notification is ScrollEndNotification) {
              ref.read(homeScrollProvider.notifier).setScrolling(false);
            }
            return false;
          },
          child: CustomScrollView(
            key: ValueKey('${isDark}_${context.locale.languageCode}'),
            physics: const BouncingScrollPhysics(),
            slivers: [
            // 1. Unified Header (Sliver)
            SliverToBoxAdapter(
              child: AppAnimation.fadeInDown(
                duration: const Duration(milliseconds: 600),
                child: UnifiedHomeHeader(scaffoldKey: _scaffoldKey),
              ),
            ),

            // 2. Main Content Sections
            SliverPadding(
              padding: EdgeInsets.only(bottom: 40.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 1. Hero Slider
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 100),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 120.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark
                                ? theme.scaffoldBackgroundColor
                                : Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32.r),
                              bottomRight: Radius.circular(32.r),
                            ),
                          ),
                        ),
                        const SliderSection(),
                      ],
                    ),
                  ),

                  // 3. Loyalty/Points Bar
                  12.verticalSpace,
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: const UserLoyaltyWidget(),
                  ),
                  24.verticalSpace,

                  // 4. Categories Row
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
                        AppSectionHeader(
                          title: LocaleKeys.webstore.home.categories_title
                              .tr(context: context),
                        ),
                        const HomeCategoriesRow(),
                      ],
                    ),
                  ),
                  16.verticalSpace,

                  // 💥 Offer Slot 1: Hero Offer (With Timer & Products Reel) - Right after Categories Row
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 320),
                    child: const OfferSlot1HeroWidget(),
                  ),

                  // 5. Feature Links (Quick Links)
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 350),
                    child: Column(
                      children: [
                        AppSectionHeader(
                          title: LocaleKeys.webstore.home.quick_links.tr(context: context),
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                        ),
                        isLoading
                            ? AppShimmer.featureLinksGrid()
                            : const FeatureLinksWidget(),
                      ],
                    ),
                  ),
                  16.verticalSpace,

                  // 💥 Offer Slot 2: Dual Banners - Right after Services
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 370),
                    child: const OfferSlot2DualWidget(),
                  ),

                  // 6. Vouchers (الكوبونات)
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: const VouchersWidget(),
                  ),
                  16.verticalSpace,

                  // 💥 Offer Slot 3: Featured Deals Carousel - Right after Vouchers
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 450),
                    child: const OfferSlot3ReelWidget(),
                  ),

                  // 7. Most Ordered (الأكثر طلباً)
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: Column(
                      children: [
                        AppSectionHeader(
                          title: LocaleKeys.webstore.home.most_ordered.tr(context: context),
                          onViewAllTap: () {
                            AppNavigator.push(
                              context,
                              AppRouteNames.webstoreCatalogProducts,
                              arguments: {'preset': 'best_seller'},
                            );
                          },
                        ),
                        12.verticalSpace,
                        const ProductGridSection(),
                      ],
                    ),
                  ),
                  16.verticalSpace,

                  // 💥 Offer Slot 4: Wide Promo Strip - Right after Most Ordered
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 650),
                    child: const OfferSlot4StripWidget(),
                  ),

                  // 8. Promotional Ads (Header is inside AdsSection now)
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 700),
                    child: const AdsSection(),
                  ),
                  12.verticalSpace,

                  // 9. Brands
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 800),
                    child: Column(
                      children: [
                        AppSectionHeader(
                          title: LocaleKeys.webstore.home.trusted_brands.tr(context: context),
                        ),
                        12.verticalSpace,
                        const CompanyProduceWidget(),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
