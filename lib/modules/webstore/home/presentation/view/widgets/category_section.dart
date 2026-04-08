import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/modules/webstore/home/data/models/webstore_mock_data.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/core/common_widget/app_horizontal_loader/app_horizontal_loader.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';


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
  final MockCategory cat;
  const _CategoryItem({required this.cat});

  Color _parseColor(String hexColor) {
    return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(cat.color);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: InkWell(
        onTap: () {},
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
                    color.withValues(alpha: isDark ? 0.3 : 0.18),
                    color.withValues(alpha: isDark ? 0.1 : 0.05),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: isDark ? 0.15 : 0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: color.withValues(alpha: isDark ? 0.4 : 0.25), 
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  cat.icon,
                  style: TextStyle(fontSize: 30.sp),
                ),
              ),
            ),
            8.verticalSpace,
            Text(
              cat.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white.withValues(alpha: 0.9) : theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
