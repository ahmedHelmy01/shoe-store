import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';
import 'package:erp/modules/webstore/wishlist/presentation/view_model/wishlist_providers.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';

// Modular Widgets
import 'widgets/details_image_gallery.dart';
import 'widgets/details_info_section.dart';
import 'widgets/details_content_section.dart';
import 'widgets/details_bottom_bar.dart';
import 'package:erp/modules/webstore/cart/presentation/view_model/cart_view_model.dart';
import 'package:erp/core/common_widget/app_error_widget/app_error_widget.dart';
import 'package:erp/core/common_widget/app_snack_bar/app_snack_bar.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

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
        error: (err, stack) => Center(
          child: AppErrorWidget(
            errorMessage: err.toString(),
            onRetry: () => ref.refresh(productDetailsProvider(widget.product.id!)),
          ),
        ),
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
            final maxStock = (fullProduct.stock != null && fullProduct.stock! > 0) ? fullProduct.stock! : 99;
            if (_quantity < maxStock) {
              setState(() => _quantity++);
            }
          },
          onDecrement: () {
            if (_quantity > 1) setState(() => _quantity--);
          },
          onAddToCart: () {
            ref.read(cartProvider.notifier).addToCart(fullProduct, quantity: _quantity);
            AppSnackBar.showSuccess(
              context,
              LocaleKeys.webstore.orders.added_to_cart.tr(context: context),
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
    final wishlist = ref.watch(wishlistProvider).value ?? [];
    final isWishlisted = product.id != null && wishlist.any((p) => p.id == product.id);

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
        _buildCircleButton(
          isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          iconColor: isWishlisted ? Colors.red : null,
          onTap: () {
            ref.read(wishlistProvider.notifier).toggleWishlist(product);
          },
        ),
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

  Widget _buildCircleButton(IconData icon, {Color? iconColor, required VoidCallback onTap}) {
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
              color: iconColor ?? (Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87),
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }
}
