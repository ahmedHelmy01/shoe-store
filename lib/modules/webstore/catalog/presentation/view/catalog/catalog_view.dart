import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/categories/category_drill_down_view.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';

class CatalogView extends ConsumerStatefulWidget {
  const CatalogView({super.key});

  @override
  ConsumerState<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends ConsumerState<CatalogView> {
  @override
  void initState() {
    super.initState();
    // Refresh from server every time this tab is entered
    Future.microtask(() {
      ref.read(catalogCategoriesProvider.notifier).getCategories(isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final categoriesState = ref.watch(catalogCategoriesProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('التصنيفات'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: categoriesState.isLoading && categoriesState.items.isEmpty
          ? AppShimmer.categoryGrid()
          : categoriesState.items.isEmpty
              ? Center(
                  child: Text(
                    'لا توجد تصنيفات',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: theme.hintColor,
                    ),
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 8.w,
                      childAspectRatio: 0.65,
                    ),
                  itemCount: categoriesState.items.length,
                  itemBuilder: (context, index) {
                    final category = categoriesState.items[index];
                    return _CategoryCard(
                      category: category,
                      isDark: isDark,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryDrillDownView(
                              categoryId: category.id!,
                              categoryName: category.name,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final dynamic category;
  final bool isDark;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.isDark,
    required this.onTap,
  });

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
  Widget build(BuildContext context) {
    final accent = _accentFor(category.name);
    final hasChildren = category.children != null && category.children.isNotEmpty;
    final productCount = category.productsCount;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50.w,
            width: 50.w,
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
                      width: 50.w,
                      height: 50.w,
                    ),
                  )
                : Icon(
                    Icons.category_rounded,
                    size: 24.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
          ),
          SizedBox(height: 6.h),
          Text(
            category.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black87,
              height: 1.2,
            ),
          ),
          if (hasChildren || productCount != null) ...[
            SizedBox(height: 2.h),
            FittedBox(
              child: Text(
                [
                  if (hasChildren) '${category.children.length} أقسام',
                  if (hasChildren && productCount != null) ' • ',
                  if (productCount != null) '$productCount منتج',
                ].join(),
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: accent,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
