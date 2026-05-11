import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';

/// Content Widgets (Description and Specifications Table)
class DetailsContentSection extends StatelessWidget {
  final WebStoreProduct product;
  const DetailsContentSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 32.h, thickness: 8, color: isDark ? Colors.white10 : Colors.grey[100]),
        _buildDescription(theme),
        if (product.attributes != null && product.attributes!.isNotEmpty)
          _buildAttributes(theme, isDark),
      ],
    );
  }

  Widget _buildDescription(ThemeData theme) {
    if (product.description == null || product.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('وصف المنتج', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)),
          12.verticalSpace,
          Text(
            product.description!.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll('&nbsp;', ' ').trim(),
            style: TextStyle(fontSize: 14.sp, height: 1.8, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributes(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 32.h, thickness: 8, color: isDark ? Colors.white10 : Colors.grey[100]),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
          child: Text('المواصفات', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)),
        ),
        ...product.attributes!.entries.map((entry) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200))),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(entry.key, style: TextStyle(fontSize: 13.sp, color: Colors.grey, fontWeight: FontWeight.w500))),
                Expanded(flex: 3, child: Text(entry.value.toString(), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: theme.textTheme.bodyLarge?.color))),
              ],
            ),
          );
        }),
      ],
    );
  }
}
