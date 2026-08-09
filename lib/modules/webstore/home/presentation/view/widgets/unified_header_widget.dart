import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/utils/asset_manager.dart';
import 'package:erp/core/common_widget/app_bottom_sheet/branch_selection_sheet.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/search_result_widget.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/providers/navigation_provider.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

class UnifiedHomeHeader extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const UnifiedHomeHeader({super.key, required this.scaffoldKey});

  @override
  ConsumerState<UnifiedHomeHeader> createState() => _UnifiedHomeHeaderState();
}

class _UnifiedHomeHeaderState extends ConsumerState<UnifiedHomeHeader> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearch() {
    FocusManager.instance.primaryFocus?.unfocus();
    final keyword = _searchController.text.trim();
    if (keyword.isEmpty) return;
    ref.read(homeVmProvider.notifier).searchProducts(keyword);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          const ProductResultBottomSheet(type: ProductSheetType.search),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final auth = ref.watch(authStateProvider);

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        bottom: 12.h,
        left: 16.w,
        right: 16.w,
      ),
      decoration: BoxDecoration(
        color: isDark ? theme.scaffoldBackgroundColor : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Row 1: Location & Action Icons
          Row(
            children: [
              InkWell(
                onTap: () => _showBranchSelection(context, ref),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primaryOrange,
                      size: 20,
                    ),
                    6.horizontalSpace,
                    Text(
                      locationState.selectedBranch ??
                          LocaleKeys.webstore.home.select_branch.tr(context: context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: theme.hintColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _buildHeaderIcon(Icons.notifications_none_rounded, () {
                AppNavigator.push(context, AppRouteNames.webstoreNotifications);
              }, theme),
              12.horizontalSpace,
              _buildHeaderIcon(Icons.shopping_bag_outlined, () {
                final isAuthed = auth.status == AuthStatus.authenticated;
                if (!isAuthed) {
                  AppNavigator.push(context, AppRouteNames.webstoreLogin);
                  return;
                }
                ref.read(webStoreNavIndexProvider.notifier).setIndex(2);
              }, theme),
            ],
          ),
          10.verticalSpace,
          // Tarshooby Logo
          Center(
            child: AppImage(
              imagePath: AssetManager.logoElTarshopy2,
              height: 100.h,
              fit: BoxFit.contain,
            ),
          ),

          // Search Showcase Card
          Container(
            margin: EdgeInsets.only(top: 6.h),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Card background with decorative circles
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A2A3A) : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Decorative medicine circles
                      Positioned(
                        top: -10.h,
                        right: -6.w,
                        child: _buildMedicineCircle(
                          size: 36.w,
                          icon: Icons.medication_rounded,
                          color: AppColors.primaryOrange,
                          opacity: 0.12,
                        ),
                      ),
                      Positioned(
                        bottom: -8.h,
                        left: 14.w,
                        child: _buildMedicineCircle(
                          size: 30.w,
                          icon: Icons.local_pharmacy_rounded,
                          color: AppColors.primaryBlue,
                          opacity: 0.10,
                        ),
                      ),
                      Positioned(
                        top: 10.h,
                        left: -10.w,
                        child: _buildMedicineCircle(
                          size: 22.w,
                          icon: Icons.healing_rounded,
                          color: const Color(0xFF4CAF50),
                          opacity: 0.10,
                        ),
                      ),
                      Positioned(
                        bottom: 6.h,
                        right: 28.w,
                        child: _buildMedicineCircle(
                          size: 20.w,
                          icon: Icons.vaccines_rounded,
                          color: AppColors.primaryBlue,
                          opacity: 0.08,
                        ),
                      ),
                      // Search field
                      Container(
                        height: 52.h,
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: _onSearch,
                              child: Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primaryOrange,
                                      AppColors.primaryOrange.withValues(alpha: 0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryOrange.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.search_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onSubmitted: (_) => _onSearch(),
                                textInputAction: TextInputAction.search,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                                decoration: InputDecoration(
                                  hintText: LocaleKeys.webstore.home.search_hint.tr(context: context),
                                  hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: theme.hintColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  filled: false,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBranchSelection(BuildContext context, WidgetRef ref) {
    BranchSelectionSheet.show(context, ref);
  }

  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap, ThemeData theme) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, color: theme.iconTheme.color, size: 24),
    );
  }

  Widget _buildMedicineCircle({
    required double size,
    required IconData icon,
    required Color color,
    required double opacity,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
      child: Icon(
        icon,
        size: size * 0.5,
        color: color.withValues(alpha: opacity + 0.1),
      ),
    );
  }
}
