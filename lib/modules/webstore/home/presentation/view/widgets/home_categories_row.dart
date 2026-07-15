import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/categories/category_drill_down_view.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';

class HomeCategoriesRow extends ConsumerWidget {
  const HomeCategoriesRow({super.key});

  Color _accentFor(String name) {
    final palette = [
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFFFFA07A),
      const Color(0xFF6C5CE7),
      const Color(0xFF00B894),
      const Color(0xFFE17055),
      const Color(0xFF0984E3),
      const Color(0xFFFDCB6E),
      const Color(0xFFE84393),
      const Color(0xFF00CEC9),
    ];
    return palette[name.hashCode.abs() % palette.length];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(catalogCategoriesProvider);

    if (state.items.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 90.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: state.items.length,
        separatorBuilder: (context, index) => 12.horizontalSpace,
        itemBuilder: (context, index) {
          final category = state.items[index];
          final displayName = Localizations.localeOf(context).languageCode == 'ar' && category.nameAr != null && category.nameAr!.isNotEmpty
              ? category.nameAr!
              : category.name;
          final accent = _accentFor(category.name);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryDrillDownView(
                    categoryId: category.id!,
                    categoryName: displayName,
                  ),
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 52.w,
                  width: 52.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [accent.withValues(alpha: 0.8), accent.withValues(alpha: 0.4)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: category.image != null && category.image!.isNotEmpty
                      ? ClipOval(
                          child: AppImage(
                            imagePath: category.image!,
                            fit: BoxFit.cover,
                            width: 52.w,
                            height: 52.w,
                          ),
                        )
                      : Icon(
                          Icons.category_rounded,
                          size: 22.sp,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  width: 60.w,
                  child: Text(
                    displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
