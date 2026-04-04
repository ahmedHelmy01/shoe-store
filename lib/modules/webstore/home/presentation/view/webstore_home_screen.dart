import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
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
import 'package:erp/core/common_provider/ads_view_model/ads_view_model.dart';

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
    ref.invalidate(companyProducesVmProvider);
    
    await Future.wait([
      ref.read(homeVmProvider.notifier).getLatestProducts(),
      ref.read(homeVmProvider.notifier).getCategories(),
      ref.read(sliderVmProvider.notifier).getSliders(),
      ref.read(adsVmProvider.notifier).getAds(),
      ref.read(companyProducesVmProvider.notifier).getCompanyProduces(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WebStoreBaseScaffold(
      scaffoldKey: _scaffoldKey,
      showAppBar: false, // Unified header handles the top area
      body: RefreshIndicator(
        onRefresh: _refreshHomeData,
        backgroundColor: Colors.white,
        color: AppColors.primaryOrange,
        child: Column(
          children: [
            // 1. Unified Fixed Header
            UnifiedHomeHeader(scaffoldKey: _scaffoldKey),
            
            // 2. Main Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Classical Horizontal Hero Slider
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 120.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32.r),
                              bottomRight: Radius.circular(32.r),
                            ),
                          ),
                        ),
                        const SliderSection(),
                      ],
                    ),
                    
                    // 3. Loyalty/Points Bar (Floating below slider)
                    12.verticalSpace,
                    const UserLoyaltyWidget(),
                    24.verticalSpace,

                    // 4. Feature Links Grid (Quick Actions)
                    _buildSectionHeader('خدماتنا الطبية السريعة'),
                    const FeatureLinksWidget(),
                    16.verticalSpace,

                    // 5. Circular Premium Categories (Online Imagery)
                    _buildSectionHeader('أقسام الصيدلية'),
                    const CategorySection(),
                    24.verticalSpace,

                    // 6. Gift Vouchers
                    const VouchersWidget(),
                    24.verticalSpace,

                    // 7. Flash Sale (Shein Style)
                    const FlashSaleWidget(),
                    24.verticalSpace,
                    
                    // 9. Rankings & Latest Products (Horizontal List)
                    _buildSectionHeader('الأكثر طلباً حالياً 🔥'),
                    12.verticalSpace,
                    const ProductGridSection(),
                    
                    24.verticalSpace,
                    // 10. Secondary Promotional Ads (New Vertical Logic)
                    _buildSectionHeader('عروض حصرية لك 🎁'),
                    const AdsSection(),
                    
                    24.verticalSpace,
                    // 11. Brand Partnerships
                    _buildSectionHeader('الماركات الموثوقة'),
                    12.verticalSpace,
                    const CompanyProduceWidget(),
                    
                    40.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textColor,
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textColor.withOpacity(0.5)),
        ],
      ),
    );
  }
}
