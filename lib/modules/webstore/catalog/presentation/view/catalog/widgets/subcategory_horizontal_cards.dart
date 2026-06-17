import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/modules/webstore/catalog/data/models/category_model.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';

class SubcategoryHorizontalCards extends ConsumerWidget {
  const SubcategoryHorizontalCards({super.key});

  static final List<Color> _palette = [
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

  static Color _colorFor(String name) {
    final hash = name.hashCode;
    return _palette[hash.abs() % _palette.length];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(catalogCategoriesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    if (state.items.isEmpty || state.selectedCategoryId == null) {
      return const SizedBox.shrink();
    }

    final selectedId = state.selectedCategoryId;

    WebStoreCategory? activeParent;
    for (final parent in state.items) {
      if (parent.id == selectedId ||
          parent.children.any((child) => child.id == selectedId)) {
        activeParent = parent;
        break;
      }
    }

    if (activeParent == null || activeParent.children.isEmpty) {
      return const SizedBox.shrink();
    }

    final subcategories = [
      WebStoreCategory(
        id: activeParent.id,
        name: isAr ? 'الكل' : 'All',
        nameAr: 'الكل',
        nameEn: 'All',
        image: activeParent.image,
      ),
      ...activeParent.children,
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: SizedBox(
        height: 86.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: subcategories.length,
          separatorBuilder: (context, index) => 8.horizontalSpace,
          itemBuilder: (context, index) {
            final subcat = subcategories[index];
            final isSelected = selectedId == subcat.id;

            return _SubcategoryCard(
              category: subcat,
              isSelected: isSelected,
              color: _colorFor(subcat.name),
              isDark: isDark,
              onTap: () {
                ref
                    .read(catalogCategoriesProvider.notifier)
                    .selectCategory(subcat.id);
              },
            );
          },
        ),
      ),
    );
  }
}

class _SubcategoryCard extends StatelessWidget {
  final WebStoreCategory category;
  final bool isSelected;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _SubcategoryCard({
    required this.category,
    required this.isSelected,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 74.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isSelected
                  ? [color, color.withValues(alpha: 0.7)]
                  : [
                      color.withValues(alpha: 0.15),
                      color.withValues(alpha: 0.05),
                    ],
            ),
            border: Border.all(
              color: isSelected
                  ? color
                  : color.withValues(alpha: 0.2),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: isSelected ? 32.h : 28.h,
                  width: isSelected ? 32.h : 28.h,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.9)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: category.image != null && category.image!.isNotEmpty
                      ? AppImage(
                          imagePath: category.image!,
                          fit: BoxFit.contain,
                        )
                      : Icon(
                          _iconFor(category.name),
                          size: 16.sp,
                          color: isSelected ? color : color.withValues(alpha: 0.7),
                        ),
                ),
                SizedBox(height: 6.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.sp,
                      height: 1.2,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.8)
                              : Colors.black.withValues(alpha: 0.7)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static IconData _iconFor(String name) {
    final n = name.toLowerCase();
    if (n.contains('tech') || n.contains('اليك') || n.contains('إلك')) return Icons.phone_android;
    if (n.contains('cloth') || n.contains('ملابس') || n.contains('ازيا')) return Icons.checkroom;
    if (n.contains('home') || n.contains('منزل') || n.contains('أثاث')) return Icons.home;
    if (n.contains('beauty') || n.contains('تجميل') || n.contains('عناية')) return Icons.spa;
    if (n.contains('food') || n.contains('طعام') || n.contains('اكل')) return Icons.restaurant;
    if (n.contains('book') || n.contains('كتاب') || n.contains('مكتب')) return Icons.menu_book;
    if (n.contains('health') || n.contains('صحة') || n.contains('طب')) return Icons.local_hospital;
    if (n.contains('sport') || n.contains('رياض')) return Icons.sports_soccer;
    if (n.contains('toy') || n.contains('لعبة') || n.contains('العاب')) return Icons.toys;
    if (n.contains('bag') || n.contains('شنط') || n.contains('حقيب')) return Icons.shopping_bag;
    if (n.contains('shoe') || n.contains('حذاء') || n.contains('جزمة')) return Icons.directions_walk;
    if (n.contains('jewel') || n.contains('مجوهر') || n.contains('ذهب')) return Icons.diamond;
    if (n.contains('all') || n.contains('الكل')) return Icons.grid_view;
    return Icons.category;
  }
}
