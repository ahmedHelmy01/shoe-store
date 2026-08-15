import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/network/network_url.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:easy_localization/easy_localization.dart';

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
  bool _isOpeningViewer = false;

  String _formatImageUrl(String url) {
    if (url.isEmpty) return '';
    if (url.startsWith('http')) return url;
    return NetworkUrl.imageUrl(url);
  }

  List<String> _getAllImages() {
    final allImages = <String>[];
    if (widget.product.image != null) {
      allImages.add(_formatImageUrl(widget.product.image!));
    }
    if (widget.product.images != null) {
      for (final img in widget.product.images!) {
        final formatted = _formatImageUrl(img);
        if (!allImages.contains(formatted)) allImages.add(formatted);
      }
    }
    if (allImages.isEmpty) allImages.add('');
    return allImages;
  }

  void _openFullScreenViewer(List<String> images) {
    if (_isOpeningViewer) return;
    _isOpeningViewer = true;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenImageViewer(
          images: images,
          initialIndex: widget.selectedImageIndex,
          heroTag: 'product_image_${widget.product.id}',
          onPageChanged: widget.onImageSelected,
        ),
      ),
    ).whenComplete(() => _isOpeningViewer = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final allImages = _getAllImages();

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _openFullScreenViewer(allImages),
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
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
              child: Hero(
                tag: 'product_image_${widget.product.id}',
                child: AppImage(
                  imagePath: allImages[widget.selectedImageIndex],
                  fit: BoxFit.contain,
                  width: double.infinity,
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

/// Full-screen image viewer with smooth pinch/double-tap zoom
/// and swipe between product images.
class FullScreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String heroTag;
  final Function(int)? onPageChanged;

  const FullScreenImageViewer({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.heroTag,
    this.onPageChanged,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: widget.images.length,
            pageController: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
              widget.onPageChanged?.call(index);
            },
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(
                value: event == null || event.expectedTotalBytes == null
                    ? null
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                color: Colors.white70,
              ),
            ),
            builder: (context, index) {
              final url = widget.images[index];
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(
                  url,
                  headers: const {
                    'User-Agent':
                        'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36',
                    'Accept':
                        'image/avif,image/webp,image/apng,image/png,image/jpg,*/*;q=0.8',
                    'Connection': 'close',
                  },
                ),
                heroAttributes: index == widget.initialIndex
                    ? PhotoViewHeroAttributes(tag: widget.heroTag)
                    : null,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 4,
                initialScale: PhotoViewComputedScale.contained,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.white38,
                    size: 48.sp,
                  ),
                ),
              );
            },
          ),
          // ─── Top bar: close button + counter ─────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTopButton(
                  icon: Icons.close_rounded,
                  onTap: () => Navigator.pop(context),
                ),
                if (widget.images.length > 1)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.images.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                SizedBox(width: 44.w),
              ],
            ),
          ),
          // ─── Bottom hint ──────────────────────────────────
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 24.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  LocaleKeys.common.pinch_to_zoom
                      .tr(context: context),
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(left: 12.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(icon, color: Colors.white, size: 20.sp),
          ),
        ),
      ),
    );
  }
}
