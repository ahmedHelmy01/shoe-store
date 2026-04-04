import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/search_result_widget.dart';

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
      builder: (context) => const ProductResultBottomSheet(type: ProductSheetType.search),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        bottom: 12.h,
        left: 16.w,
        right: 16.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Row 1: Location & Action Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  // Open location picker
                },
                child: Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: AppColors.primaryOrange, size: 18),
                    4.horizontalSpace,
                    Text(
                      locationState.selectedBranch ?? 'اختر الفرع',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textColor, size: 18),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildHeaderIcon(Icons.notifications_none_rounded, () {}),
                  12.horizontalSpace,
                  _buildHeaderIcon(Icons.shopping_bag_outlined, () {}),
                ],
              ),
            ],
          ),
          12.verticalSpace,
          // Row 2: Search Bar
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _onSearch(),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن دواء، مستلزمات طبية...',
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[500],
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
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
                  child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, color: AppColors.textColor, size: 24),
    );
  }
}
