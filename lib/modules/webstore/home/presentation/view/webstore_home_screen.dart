import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/unified_header_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/loyalty_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/vouchers_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/feature_links_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/category_section.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/ads_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/product_grid_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/company_produce_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/slider_widget.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/flash_sale_widget.dart';
import 'package:erp/core/common_widget/app_section_header/app_section_header.dart';
import 'package:erp/core/common_provider/ads_view_model/ads_view_model.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';

class WebStoreHomeScreen extends ConsumerStatefulWidget {
  const WebStoreHomeScreen({super.key});

  @override
  ConsumerState<WebStoreHomeScreen> createState() => _WebStoreHomeScreenState();
}

class _WebStoreHomeScreenState extends ConsumerState<WebStoreHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _refreshHomeData() async {
    ref.invalidate(homeVmProvider);
    ref.invalidate(adsVmProvider);
    ref.invalidate(sliderVmProvider);
    ref.invalidate(companyProducesVmProvider);

    await Future.wait<void>([
      ref.read(homeVmProvider.notifier).getLatestProducts(),
      ref.read(homeVmProvider.notifier).getCategories(),
      ref.read(sliderVmProvider.notifier).getSliders(),
      ref.read(adsVmProvider.notifier).getAds(),
      ref.read(companyProducesVmProvider.notifier).getCompanyProduces(),
    ]);
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
        child: CustomScrollView(
          key: ValueKey(isDark),
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
                            color: isDark ? theme.scaffoldBackgroundColor : Colors.white,
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

                  // 4. Feature Links
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
                        AppSectionHeader(title: LocaleKeys.webstore.home.medical_services.tr()),
                        isLoading ? AppShimmer.featureLinksGrid() : const FeatureLinksWidget(),
                      ],
                    ),
                  ),
                  16.verticalSpace,

                  // 5. Categories
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: Column(
                      children: [
                        AppSectionHeader(title: LocaleKeys.webstore.home.pharmacy_sections.tr()),
                        const CategorySection(),
                      ],
                    ),
                  ),
                  24.verticalSpace,

                  // 6. Vouchers
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: const VouchersWidget(),
                  ),
                  24.verticalSpace,

                  // 7. Flash Sale
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: const FlashSaleWidget(),
                  ),
                  24.verticalSpace,

                  // 9. Most Ordered
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 700),
                    child: Column(
                      children: [
                        AppSectionHeader(title: LocaleKeys.webstore.home.most_ordered.tr(), onViewAllTap: () {}),
                        12.verticalSpace,
                        const ProductGridSection(),
                      ],
                    ),
                  ),
                  24.verticalSpace,

                  // 10. Promotional Ads (Header is inside AdsSection now)
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 800),
                    child: const AdsSection(),
                  ),
                  12.verticalSpace,

                  // 11. Brands
                  AppAnimation.fadeInUp(
                    delay: const Duration(milliseconds: 900),
                    child: Column(
                      children: [
                        AppSectionHeader(title: LocaleKeys.webstore.home.trusted_brands.tr()),
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
    );
  }
}
