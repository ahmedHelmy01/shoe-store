import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';

/// Combined Basic Info Widgets (Price, Title, Rating, Stock)
class DetailsInfoSection extends StatelessWidget {
  final WebStoreProduct product;
  const DetailsInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🏷️ Manufacturer & Tags Row
        _buildTopBadges(),
        
        _buildPrice(theme),
        _buildTitle(theme),
        _buildRating(),
        
        // 📋 Technical Details (SKU, Barcode)
        _buildTechnicalInfo(context, theme, isDark),

        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Divider(
            height: 1,
            thickness: 1,
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1),
          ),
        ),
        _buildStock(),
      ],
    );
  }

  Widget _buildTopBadges() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Manufacturer
          if (product.manufacturer != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.factory_outlined, size: 14.sp, color: AppColors.primaryBlue),
                  6.horizontalSpace,
                  Text(
                    product.manufacturer!['name_ar'] ?? product.manufacturer!['name'] ?? '',
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                  ),
                ],
              ),
            ),
          
          // Tags
          if (product.tags != null)
            ...product.tags!.map((tag) => Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '# $tag',
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: Colors.green),
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildTechnicalInfo(BuildContext context, ThemeData theme, bool isDark) {
    if (product.sku == null && product.barcode == null) return const SizedBox.shrink();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : theme.primaryColor.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : theme.primaryColor.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          if (product.sku != null)
            _buildInfoRow(context, Icons.tag_rounded, 'رمز المنتج (SKU)', product.sku!),
          if (product.sku != null && product.barcode != null) 8.verticalSpace,
          if (product.barcode != null)
            _buildInfoRow(context, Icons.qr_code_scanner_rounded, 'الباركود', product.barcode!, isBarcode: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value, {bool isBarcode = false}) {
    final content = Row(
      children: [
        Icon(icon, size: 16.sp, color: Colors.grey),
        8.horizontalSpace,
        Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        if (isBarcode) ...[
          6.horizontalSpace,
          Icon(Icons.fullscreen, size: 14.sp, color: Colors.grey.shade400),
        ],
      ],
    );

    if (!isBarcode) return content;

    return GestureDetector(
      onTap: () => _showBarcodeQr(context, value),
      child: content,
    );
  }

  void _showBarcodeQr(BuildContext context, String barcode) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(barcode, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
              20.verticalSpace,
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: QrImageView(
                  data: barcode,
                  version: QrVersions.auto,
                  size: 250.w,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.black),
                  dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Colors.black),
                ),
              ),
              16.verticalSpace,
              Text('امسح الرمز ضوئيًا في المتجر', style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrice(ThemeData theme) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            product.price.toStringAsFixed(3),
            style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w900, color: theme.textTheme.bodyLarge?.color),
          ),
          4.horizontalSpace,
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Text(AppConstants.currency, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.primaryOrange)),
          ),
          12.horizontalSpace,
          if (product.hasDiscount) ...[
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Text('${product.oldPrice?.toStringAsFixed(3)} ${AppConstants.currency}', style:  TextStyle(fontSize: 14.sp, color: Colors.grey, decoration: TextDecoration.lineThrough)),
            ),
            8.horizontalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6.r)),
              child: Text('-${product.discountPercent.toStringAsFixed(0)}%', style:  TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.red)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        product.name,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, height: 1.4, color: theme.textTheme.bodyLarge?.color),
      ),
    );
  }

  Widget _buildRating() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Row(
        children: [
          ...List.generate(5, (i) {
            final rating = product.rating ?? 0;
            return Icon(
              i < rating.floor() ? Icons.star_rounded : (i < rating ? Icons.star_half_rounded : Icons.star_outline_rounded),
              color: Colors.amber,
              size: 20.sp,
            );
          }),
          8.horizontalSpace,
          Text('${product.rating ?? 0}', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
          4.horizontalSpace,
          Text('(${product.reviewsCount ?? 0} تقييم)', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStock() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Icon(product.isInStock ? Icons.check_circle_rounded : Icons.cancel_rounded, color: product.isInStock ? Colors.green : Colors.red, size: 20.sp),
          8.horizontalSpace,
          Text(product.isInStock ? 'متوفر في المخزن' : 'غير متوفر حالياً', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: product.isInStock ? Colors.green : Colors.red)),
          const Spacer(),
          if (product.isInStock) Text('الكمية: ${product.stock}', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
        ],
      ),
    );
  }
}
