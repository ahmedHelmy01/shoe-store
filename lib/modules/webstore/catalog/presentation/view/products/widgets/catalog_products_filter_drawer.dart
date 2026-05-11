import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
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
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFFEAEAEA)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'فلترة متقدمة',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    'اختر القسم، نطاق السعر، التاج، والأولوية للحصول على نتائج أدق',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            16.verticalSpace,
            AppDropdown<int?>(
              label: 'القسم',
              hint: 'اختر القسم',
              value: selectedCategoryId,
              borderColor: const Color(0xFFE8E8E8),
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
                  child: Text('كل الأقسام'),
                ),
                ...categories.map(
                  (category) => DropdownMenuItem<int?>(
                    value: category.id,
                    child: Text(category.name),
                  ),
                ),
              ],
              onChanged: onCategoryChanged,
            ),
            16.verticalSpace,
            AppDropdown<int?>(
              label: 'الشركة المصنعة',
              hint: 'اختر الشركة',
              value: selectedManufacturerId,
              borderColor: const Color(0xFFE8E8E8),
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
              borderColor: const Color(0xFFE8E8E8),
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
                  label: 'الاسم',
                  selected: sortBy == 'name',
                  onSelected: () => onSortByChanged('name'),
                ),
                _choiceChip(
                  label: 'السعر',
                  selected: sortBy == 'sale_price',
                  onSelected: () => onSortByChanged('sale_price'),
                ),
                _choiceChip(
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
                  label: 'تصاعدي',
                  selected: sortDir == 'asc',
                  onSelected: () => onSortDirChanged('asc'),
                ),
                _choiceChip(
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
                color: const Color(0xFFF9F9F9),
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
              tileColor: const Color(0xFFF9F9F9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              value: onlyInStock,
              title: const Text('المتاح فقط'),
              onChanged: onOnlyInStockChanged,
              contentPadding: EdgeInsets.zero,
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
                          color: AppColors.primaryOrange.withValues(
                            alpha: 0.35,
                          ),
                        ),
                      ),
                      onPressed: onReset,
                      child: const Text('إعادة تعيين'),
                    ),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      onPressed: onApply,
                      child: const Text('عرض النتائج'),
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
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: const Color(0xFFF3F4F6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      side: BorderSide(
        color: selected
            ? AppColors.primaryOrange.withValues(alpha: 0.6)
            : const Color(0xFFE5E5E5),
      ),
      labelStyle: TextStyle(
        color: selected ? AppColors.primaryOrange : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Colors.white,
    );
  }
}

class _ChipSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ChipSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
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
              color: Colors.black87,
            ),
          ),
          8.verticalSpace,
          Wrap(spacing: 8.w, runSpacing: 8.h, children: children),
        ],
      ),
    );
  }
}
