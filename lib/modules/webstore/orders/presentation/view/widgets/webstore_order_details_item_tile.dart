import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/constants/app_constants.dart';

class WebStoreOrderDetailsItemTile extends StatelessWidget {
  final Map<String, dynamic> item;

  const WebStoreOrderDetailsItemTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = item['product_name']?.toString() ?? '';
    final nameAr = item['product_name_ar']?.toString() ?? '';
    final displayName = Localizations.localeOf(context).languageCode == 'ar' ? nameAr : name;
    final qty = item['quantity'] ?? 1;
    final unitPrice = item['unit_price']?.toString() ?? '0.00';
    final totalPrice = item['total']?.toString() ?? '0.00';
    final discount = item['discount']?.toString() ?? '0.000';
    final hasDiscount = double.tryParse(discount) != null && double.parse(discount) > 0;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // Product icon placeholder
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.primaryWine.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.inventory_2_outlined, color: AppColors.primaryWine, size: 24.sp),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                4.verticalSpace,
                Row(
                  children: [
                    Text(
                      '${LocaleKeys.webstore.orders.quantity.tr(context: context)} $qty',
                      style: TextStyle(fontSize: 12.sp, color: theme.hintColor),
                    ),
                    if (hasDiscount) ...[
                      8.horizontalSpace,
                      Text(
                        '${LocaleKeys.webstore.orders.discount.tr(context: context)}: $discount',
                        style: TextStyle(fontSize: 11.sp, color: AppColors.success),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$totalPrice ${AppConstants.currency}',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              if (qty > 1)
                Text(
                  '$unitPrice ${LocaleKeys.webstore.orders.each.tr(context: context)}',
                  style: TextStyle(fontSize: 11.sp, color: theme.hintColor),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
