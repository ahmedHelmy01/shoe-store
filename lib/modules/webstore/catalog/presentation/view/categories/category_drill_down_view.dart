import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/modules/webstore/catalog/data/models/category_model.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/products/catalog_products_view.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';

class CategoryDrillDownView extends ConsumerWidget {
  final int categoryId;
  final String categoryName;

  const CategoryDrillDownView({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(catalogCategoriesProvider);
    final category = _findCategory(state.items, categoryId);

    if (category == null) {
      return Scaffold(
        appBar: AppBar(title: Text(categoryName)),
        body: const Center(child: Text('التصنيف غير موجود')),
      );
    }

    if (category.children.isNotEmpty) {
      return _ChildrenScreen(category: category);
    }

    return _ProductsScreen(category: category);
  }

  WebStoreCategory? _findCategory(List<WebStoreCategory> items, int id) {
    for (final item in items) {
      if (item.id == id) return item;
      final found = _findCategory(item.children, id);
      if (found != null) return found;
    }
    return null;
  }
}

class _ChildrenScreen extends StatelessWidget {
  final WebStoreCategory category;

  const _ChildrenScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 8.w,
          childAspectRatio: 0.65,
        ),
        itemCount: category.children.length,
        itemBuilder: (context, index) {
          final child = category.children[index];
          return _CategoryCard(
            category: child,
            isDark: isDark,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryDrillDownView(
                    categoryId: child.id!,
                    categoryName: child.name,
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

class _ProductsScreen extends StatelessWidget {
  final WebStoreCategory category;

  const _ProductsScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return CatalogProductsView(
      initialCategoryId: category.id,
      initialScreenTitle: category.name,
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final WebStoreCategory category;
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
    final hasChildren = category.children.isNotEmpty;
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
