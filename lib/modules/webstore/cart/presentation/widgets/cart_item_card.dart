import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/core/constants/app_constants.dart';

class CartItemCard extends StatelessWidget {
  final WebStoreProduct product;
  final int quantity;
  final VoidCallback? onRemove;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const CartItemCard({
    super.key,
    required this.product,
    this.quantity = 1,
    this.onRemove,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove?.call(),
      background: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(Icons.delete_outline_rounded, color: Colors.red, size: 28.sp),
      ),
      child: AppCard(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[50],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: AppImage(
                  imagePath: product.image ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            16.horizontalSpace,

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.hintColor, size: 20.sp),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  4.verticalSpace,
                  
                  // Quantity and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity Selector
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            _buildQtyBtn(Icons.remove, onDecrement),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Text(
                                '$quantity',
                                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
                              ),
                            ),
                            _buildQtyBtn(Icons.add, onIncrement),
                          ],
                        ),
                      ),
                      
                      // Price
                      Text(
                        '${(product.price * quantity).toStringAsFixed(2)} ${AppConstants.currency}',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, size: 16.sp, color: AppColors.primaryOrange),
    );
  }
}
