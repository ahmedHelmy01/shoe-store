import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';

class DetailsImageGallery extends StatefulWidget {
  final WebStoreProduct product;
  final int selectedImageIndex;
  final Function(int) onImageSelected;

  const DetailsImageGallery({
    super.key,
    required this.product,
    required this.selectedImageIndex,
    required this.onImageSelected,
  });

  @override
  State<DetailsImageGallery> createState() => _DetailsImageGalleryState();
}

class _DetailsImageGalleryState extends State<DetailsImageGallery> {
  final TransformationController _transformController = TransformationController();
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _transformController.addListener(_onTransformChanged);
  }

  @override
  void didUpdateWidget(DetailsImageGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedImageIndex != widget.selectedImageIndex) {
      _resetZoom();
    }
  }

  @override
  void dispose() {
    _transformController.removeListener(_onTransformChanged);
    _transformController.dispose();
    super.dispose();
  }

  void _onTransformChanged() {
    final scale = _transformController.value.getMaxScaleOnAxis();
    if (_isZoomed && scale <= 1.05) {
      setState(() => _isZoomed = false);
    } else if (!_isZoomed && scale > 1.05) {
      setState(() => _isZoomed = true);
    }
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
    setState(() => _isZoomed = false);
  }

  void _toggleZoom() {
    if (_isZoomed) {
      _resetZoom();
    } else {
      _transformController.value = Matrix4.diagonal3Values(3.0, 3.0, 1.0);
      setState(() => _isZoomed = true);
    }
  }

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
    if (widget.product.image != null) {
      allImages.add(
        _formatImageUrl(widget.product.image!));
    }
    if (widget.product.images != null) {
      for (final img in widget.product.images!) {
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
              if (!_isZoomed && details.primaryVelocity != null) {
                if (details.primaryVelocity! < 0 &&
                    widget.selectedImageIndex < allImages.length - 1) {
                  widget.onImageSelected(widget.selectedImageIndex + 1);
                } else if (details.primaryVelocity! > 0 &&
                    widget.selectedImageIndex > 0) {
                  widget.onImageSelected(widget.selectedImageIndex - 1);
                }
              }
            },
            child: Container(
              color: isDark ? Colors.grey[900] : Colors.grey[50],
              child: Stack(
                children: [
                  InteractiveViewer(
                    transformationController: _transformController,
                    panEnabled: true,
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: AppImage(
                      imagePath: allImages[widget.selectedImageIndex],
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    bottom: 8.h,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: _toggleZoom,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Icon(
                          _isZoomed ? Icons.zoom_out : Icons.zoom_in,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ],
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
                final isSelected = index == widget.selectedImageIndex;
                return GestureDetector(
                  onTap: () => widget.onImageSelected(index),
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
                      child: AppImage(
                        imagePath: allImages[index],
                        fit: BoxFit.cover,
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
