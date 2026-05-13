import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';

// Modular Widgets
import 'widgets/details_image_gallery.dart';
import 'widgets/details_info_section.dart';
import 'widgets/details_content_section.dart';
import 'widgets/details_bottom_bar.dart';

class ProductDetailsView extends ConsumerStatefulWidget {
  final WebStoreProduct product;

  const ProductDetailsView({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends ConsumerState<ProductDetailsView> {
  int _selectedImageIndex = 0;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 🔄 Fetch full product details using ID
    final detailsAsync = ref.watch(productDetailsProvider(widget.product.id!));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: detailsAsync.when(
        loading: () => _buildShimmerLoading(),
        error: (err, stack) => Center(child: Text('خطأ في جلب البيانات: $err')),
        data: (fullProduct) => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ─── Collapsing App Bar with Image Gallery ──────────
            _buildAppBar(isDark, theme, fullProduct),

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailsInfoSection(product: fullProduct),
                  DetailsContentSection(product: fullProduct),
                  80.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: detailsAsync.maybeWhen(
        data: (fullProduct) => DetailsBottomBar(
          product: fullProduct,
          quantity: _quantity,
          onIncrement: () {
            if (_quantity < (fullProduct.stock ?? 99)) {
              setState(() => _quantity++);
            }
          },
          onDecrement: () {
            if (_quantity > 1) setState(() => _quantity--);
          },
          onAddToCart: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تمت إضافة $_quantity من "${fullProduct.name}" إلى السلة',
                ),
                backgroundColor: AppColors.primaryOrange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            );
          },
        ),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            AppShimmer.box(width: 350.w, height: 200.h),
            20.verticalSpace,
            AppShimmer.box(width: 300.w, height: 30.h),
            20.verticalSpace,
            AppShimmer.box(width: double.infinity, height: 400.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark, ThemeData theme, WebStoreProduct product) {
    return SliverAppBar(
      expandedHeight: 380.h,
      pinned: true,
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.white,
      leading: _buildCircleButton(
        Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.pop(context),
      ),
      actions: [
        _buildCircleButton(Icons.share_rounded, onTap: () {}),
        8.horizontalSpace,
        _buildCircleButton(Icons.favorite_border_rounded, onTap: () {}),
        12.horizontalSpace,
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: DetailsImageGallery(
          product: product,
          selectedImageIndex: _selectedImageIndex,
          onImageSelected: (index) =>
              setState(() => _selectedImageIndex = index),
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 8.h),
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ColorFilter.mode(
              Colors.black.withOpacity(0.1),
              BlendMode.darken,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }
}
