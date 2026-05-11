import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/core/common_widget/app_horizontal_loader/app_horizontal_loader.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/catalog/data/models/category_model.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/constants/app_constants.dart';

class CategorySection extends ConsumerWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(homeVmProvider.select((s) => s.categories));
    
    if (categories.isEmpty) {
      return AppHorizontalLoader(height: 90.h, itemWidth: 70.w, borderRadius: 35);
    }

    return AppAnimation.fadeInUp(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: categories.map((cat) => _CategoryItem(cat: cat)).toList(),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final WebStoreCategory cat;
  const _CategoryItem({required this.cat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Define a consistent color scheme for categories if not provided by API
    final Color categoryColor = AppColors.primaryOrange; 

    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: InkWell(
        onTap: () {
          // Navigate to category products
        },
        borderRadius: BorderRadius.circular(40.r),
        child: Column(
          children: [
            Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    categoryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                    categoryColor.withValues(alpha: isDark ? 0.05 : 0.02),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: categoryColor.withValues(alpha: isDark ? 0.1 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: categoryColor.withValues(alpha: isDark ? 0.3 : 0.15), 
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: cat.image != null && cat.image!.isNotEmpty
                  ? AppImage(
                      imagePath: cat.image!,
                      width: 40.w,
                      height: 40.w,
                      fit: BoxFit.contain,
                    )
                  : Center(
                      child: Icon(
                        Icons.category_outlined,
                        color: categoryColor,
                        size: 30.sp,
                      ),
                    ),
              ),
            ),
            8.verticalSpace,
            SizedBox(
              width: 80.w,
              child: Text(
                cat.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white.withValues(alpha: 0.9) : theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
