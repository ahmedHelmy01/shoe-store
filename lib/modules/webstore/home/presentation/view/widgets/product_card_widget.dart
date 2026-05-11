import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/common_widget/app_price_text/app_price_text.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/product_details/product_details_view.dart';

class ProductGridCard extends ConsumerWidget {
  final WebStoreProduct product;
  final int? ranking;
  const ProductGridCard({super.key, required this.product, this.ranking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bool hasDiscount =
        product.oldPrice != null && product.oldPrice! > product.price;
    final int discountPct = hasDiscount
        ? (((product.oldPrice! - product.price) / product.oldPrice!) * 100)
            .toInt()
        : 0;

    return AppCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsView(product: product),
          ),
        );
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[50],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                    ),
                    border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.05)) : null,
                  ),
                  padding: EdgeInsets.all(12.w),
                  child: AppImage(
                    imagePath: product.image ?? '',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Product Info
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: theme.textTheme.bodyLarge?.color,
                              height: 1.2,
                            ),
                          ),
                          4.verticalSpace,
                          if (product.brand != null)
                            Text(
                              product.brand!,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: isDark ? Colors.white.withValues(alpha: 0.5) : theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppPriceText(
                            price: product.price,
                            oldPrice: product.oldPrice,
                          ),
                          Container(
                            height: 32.h,
                            width: 32.h,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryOrange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add_shopping_cart,
                                color: Colors.white, size: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Ranking Badge (#1, #2, #3)
          if (ranking != null && ranking! <= 3)
            Positioned(
              top: 0,
              right: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: ranking == 1 ? const Color(0xFFFFD700) : (ranking == 2 ? const Color(0xFFC0C0C0) : const Color(0xFFCD7F32)),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.r)),
                ),
                child: Text(
                  '#$ranking',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          // Discount Badge
          if (hasDiscount)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '-$discountPct%',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
