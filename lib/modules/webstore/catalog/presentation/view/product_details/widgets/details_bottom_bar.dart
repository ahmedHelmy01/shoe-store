import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';

class DetailsBottomBar extends StatelessWidget {
  final WebStoreProduct product;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAddToCart;

  const DetailsBottomBar({
    super.key,
    required this.product,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.grey[100], borderRadius: BorderRadius.circular(12.r)),
              child: Row(
                children: [
                  _buildQtyButton(Icons.remove, onDecrement),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text('$quantity', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  ),
                  _buildQtyButton(Icons.add, onIncrement),
                ],
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: SizedBox(
                height: 50.h,
                child: ElevatedButton(
                  onPressed: product.isInStock ? onAddToCart : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    disabledBackgroundColor: Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_cart_rounded),
                      8.horizontalSpace,
                      Text(product.isInStock ? 'أضف إلى السلة' : 'غير متوفر', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(padding: EdgeInsets.all(10.w), child: Icon(icon, size: 20.sp)),
    );
  }
}
