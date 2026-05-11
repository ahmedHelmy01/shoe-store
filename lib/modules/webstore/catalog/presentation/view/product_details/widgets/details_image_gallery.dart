import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';

class DetailsImageGallery extends StatelessWidget {
  final WebStoreProduct product;
  final int selectedImageIndex;
  final Function(int) onImageSelected;

  const DetailsImageGallery({
    super.key,
    required this.product,
    required this.selectedImageIndex,
    required this.onImageSelected,
  });

  String _formatImageUrl(String url) {
    if (url.isEmpty) return '';
    if (url.startsWith('http')) return url;
    return 'https://moon-erp.elbaset.com/storage/$url';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final allImages = <String>[];
    if (product.image != null) allImages.add(_formatImageUrl(product.image!));
    if (product.images != null) {
      for (final img in product.images!) {
        final formatted = _formatImageUrl(img);
        if (!allImages.contains(formatted)) allImages.add(formatted);
      }
    }
    if (allImages.isEmpty) allImages.add('');

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! < 0 &&
                    selectedImageIndex < allImages.length - 1) {
                  onImageSelected(selectedImageIndex + 1);
                } else if (details.primaryVelocity! > 0 &&
                    selectedImageIndex > 0) {
                  onImageSelected(selectedImageIndex - 1);
                }
              }
            },
            child: Container(
              color: isDark ? Colors.grey[900] : Colors.grey[50],
              child: Image.network(
                allImages[selectedImageIndex],
                fit: BoxFit.contain,
                width: double.infinity,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: Container(color: Colors.white),
                  );
                },
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 60.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (allImages.length > 1)
          Container(
            height: 70.h,
            color: isDark ? theme.cardColor : Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              itemCount: allImages.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedImageIndex;
                return GestureDetector(
                  onTap: () => onImageSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 54.w,
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryOrange
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7.r),
                      child: Image.network(
                        allImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image, size: 20),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
