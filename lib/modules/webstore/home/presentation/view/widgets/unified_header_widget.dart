import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/utils/asset_manager.dart';
import 'package:erp/core/common_widget/app_bottom_sheet/branch_selection_sheet.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/search_result_widget.dart';
import 'package:erp/core/providers/core_providers.dart';

class UnifiedHomeHeader extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const UnifiedHomeHeader({super.key, required this.scaffoldKey});

  @override
  ConsumerState<UnifiedHomeHeader> createState() => _UnifiedHomeHeaderState();
}

class _UnifiedHomeHeaderState extends ConsumerState<UnifiedHomeHeader> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearch() {
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
                          LocaleKeys.webstore.home.select_branch.tr(
                            context: context,
                          ),
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
              _buildHeaderIcon(Icons.notifications_none_rounded, () {}, theme),
              12.horizontalSpace,
              _buildHeaderIcon(Icons.shopping_bag_outlined, () {}, theme),
            ],
          ),
          10.verticalSpace,
          // Tarshooby Logo
          Center(
            child: AppImage(
              imagePath: AssetManager.logoElTarshopy,
              height: 100.h,
              fit: BoxFit.contain,
            ),
          ),

          // Row 2: Search Bar
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: isDark ? theme.cardColor : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.grey[200]!,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _onSearch(),
                    textInputAction: TextInputAction.search,
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                    decoration: InputDecoration(
                      hintText: LocaleKeys.webstore.home.search_hint.tr(
                        context: context,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: theme.hintColor,
                      ),
                      prefixIcon: Icon(Icons.search, color: theme.hintColor),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
              ),
              12.horizontalSpace,
              InkWell(
                onTap: () => widget.scaffoldKey.currentState?.openDrawer(),
                child: Container(
                  height: 48.h,
                  width: 48.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
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
}
