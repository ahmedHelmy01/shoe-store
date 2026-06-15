import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/core/common_widget/app_dropdown/category_tree_dropdown.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/data/models/category_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/manufacturer_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/tag_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CatalogProductsFilterDrawer extends StatelessWidget {
  final List<WebStoreCategory> categories;
  final List<ManufacturerModel> manufacturers;
  final List<TagModel> tags;
  final int? selectedCategoryId;
  final int? selectedManufacturerId;
  final int? selectedTagId;
  final String sortBy;
  final String sortDir;
  final bool onlyInStock;
  final RangeValues priceValues;
  final ValueChanged<int?> onCategoryChanged;
  final ValueChanged<int?> onManufacturerChanged;
  final ValueChanged<int?> onTagChanged;
  final ValueChanged<String> onSortByChanged;
  final ValueChanged<String> onSortDirChanged;
  final ValueChanged<RangeValues> onPriceChanged;
  final ValueChanged<bool> onOnlyInStockChanged;
  final VoidCallback onReset;
  final VoidCallback onApply;

  const CatalogProductsFilterDrawer({
    super.key,
    required this.categories,
    required this.manufacturers,
    required this.tags,
    required this.selectedCategoryId,
    required this.selectedManufacturerId,
    required this.selectedTagId,
    required this.sortBy,
    required this.sortDir,
    required this.onlyInStock,
    required this.priceValues,
    required this.onCategoryChanged,
    required this.onManufacturerChanged,
    required this.onTagChanged,
    required this.onSortByChanged,
    required this.onSortDirChanged,
    required this.onPriceChanged,
    required this.onOnlyInStockChanged,
    required this.onReset,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: isDark ? Colors.white10 : const Color(0xFFEAEAEA),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'فلترة متقدمة',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    'اختر القسم، نطاق السعر، التاج، والأولوية للحصول على نتائج أدق',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            16.verticalSpace,
            CategoryTreeDropdown(
              label: 'القسم',
              hint: 'كل الأقسام',
              value: selectedCategoryId,
              items: [
                const CategoryTreeItem(
                  id: null,
                  name: 'كل الأقسام',
                  isChild: false,
                ),
                ...CategoryTreeDropdown.flattenTree(
                  categories.map((e) => e.toJson()).toList(),
                ),
              ],
              onChanged: onCategoryChanged,
            ),
            16.verticalSpace,
            AppDropdown<int?>(
              label: 'الشركة المصنعة',
              hint: 'اختر الشركة',
              value: selectedManufacturerId,
              borderColor: isDark ? Colors.white10 : const Color(0xFFE8E8E8),
              focusedBorderColor: AppColors.primaryOrange,
              fieldHeight: 48.h,
              menuMaxHeight: 320.h,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('كل الشركات'),
                ),
                ...manufacturers.map(
                  (m) => DropdownMenuItem<int?>(
                    value: m.id,
                    child: Text(m.nameAr ?? m.nameEn ?? m.name),
                  ),
                ),
              ],
              onChanged: onManufacturerChanged,
            ),
            16.verticalSpace,
            AppDropdown<int?>(
              label: 'التاج',
              hint: 'اختر التاج',
              value: selectedTagId,
              borderColor: isDark ? Colors.white10 : const Color(0xFFE8E8E8),
              focusedBorderColor: AppColors.primaryOrange,
              fieldHeight: 48.h,
              menuMaxHeight: 320.h,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('كل التاجات'),
                ),
                ...tags.map(
                  (tag) => DropdownMenuItem<int?>(
                    value: tag.id,
                    child: Text(tag.nameAr ?? tag.nameEn ?? tag.name),
                  ),
                ),
              ],
              onChanged: onTagChanged,
            ),
            16.verticalSpace,
            _ChipSection(
              title: 'الترتيب حسب',
              children: [
                _choiceChip(
                  context: context,
                  label: 'الاسم',
                  selected: sortBy == 'name',
                  onSelected: () => onSortByChanged('name'),
                ),
                _choiceChip(
                  context: context,
                  label: 'السعر',
                  selected: sortBy == 'sale_price',
                  onSelected: () => onSortByChanged('sale_price'),
                ),
                _choiceChip(
                  context: context,
                  label: 'تاريخ الإضافة',
                  selected: sortBy == 'created_at',
                  onSelected: () => onSortByChanged('created_at'),
                ),
              ],
            ),
            16.verticalSpace,
            _ChipSection(
              title: 'اتجاه الترتيب',
              children: [
                _choiceChip(
                  context: context,
                  label: 'تصاعدي',
                  selected: sortDir == 'asc',
                  onSelected: () => onSortDirChanged('asc'),
                ),
                _choiceChip(
                  context: context,
                  label: 'تنازلي',
                  selected: sortDir == 'desc',
                  onSelected: () => onSortDirChanged('desc'),
                ),
              ],
            ),
            16.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'نطاق السعر (${priceValues.start.toInt()} - ${priceValues.end.toInt()})',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  RangeSlider(
                    values: priceValues,
                    min: 0,
                    max: 1000,
                    activeColor: AppColors.primaryOrange,
                    inactiveColor: AppColors.primaryOrange.withOpacity(0.2),
                    divisions: 20,
                    labels: RangeLabels(
                      priceValues.start.toStringAsFixed(0),
                      priceValues.end.toStringAsFixed(0),
                    ),
                    onChanged: onPriceChanged,
                  ),
                ],
              ),
            ),
            12.verticalSpace,
            SwitchListTile(
              tileColor: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF9F9F9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              activeColor: AppColors.primaryOrange,
              value: onlyInStock,
              title: Text('المتاح فقط', style: theme.textTheme.bodyMedium),
              onChanged: onOnlyInStockChanged,
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
            ),
            24.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        side: BorderSide(
                          color: AppColors.primaryOrange.withOpacity(0.35),
                        ),
                      ),
                      onPressed: onReset,
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('إعادة تعيين'),
                      ),
                    ),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      onPressed: onApply,
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('عرض النتائج'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceChip({
    required BuildContext context,
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primaryOrange.withOpacity(isDark ? 0.2 : 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      side: BorderSide(
        color: selected
            ? AppColors.primaryOrange.withOpacity(0.6)
            : (isDark ? Colors.white10 : const Color(0xFFE5E5E5)),
      ),
      labelStyle: TextStyle(
        color: selected ? AppColors.primaryOrange : theme.textTheme.bodyMedium?.color,
        fontWeight: FontWeight.w600,
        fontSize: 12.sp,
      ),
      backgroundColor: Colors.transparent,
    );
  }
}

class _ChipSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ChipSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          8.verticalSpace,
          Wrap(spacing: 8.w, runSpacing: 8.h, children: children),
        ],
      ),
    );
  }
}
