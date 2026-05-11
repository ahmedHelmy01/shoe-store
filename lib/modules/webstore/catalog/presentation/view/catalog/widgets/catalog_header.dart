import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';

class CatalogHeader extends ConsumerWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  const CatalogHeader({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: controller,
                style: TextStyle(fontSize: 14.sp),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'بحث عن منتجات طبية...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
                  prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.grey),
                          onPressed: onClear,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                ),
                onChanged: (val) {
                  // Rebuild to show/hide clear icon
                  (context as Element).markNeedsBuild();
                },
                onSubmitted: (value) => onSearch(),
              ),
            ),
          ),
          8.horizontalSpace,
          Container(
            height: 45.h,
            width: 45.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryOrange, Color(0xFFFF8C00)],
              ),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              onPressed: onSearch,
              icon: Icon(Icons.search_rounded, color: Colors.white, size: 22.sp),
            ),
          ),
        ],
      ),
    );
  }
}
