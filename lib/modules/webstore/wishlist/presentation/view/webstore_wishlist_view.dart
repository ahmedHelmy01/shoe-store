import 'package:erp/modules/webstore/catalog/presentation/view/products/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/wishlist/presentation/view_model/wishlist_providers.dart';

class WebStoreWishlistView extends ConsumerStatefulWidget {
  const WebStoreWishlistView({super.key});

  @override
  ConsumerState<WebStoreWishlistView> createState() => _WebStoreWishlistViewState();
}

class _WebStoreWishlistViewState extends ConsumerState<WebStoreWishlistView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wishlistAsync = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(titleText: 'webstore.more.wishlist'.tr(context: context)),
      body: wishlistAsync.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 60.sp, color: Colors.red),
              16.verticalSpace,
              Text(
                'حدث خطأ ما: $err',
                style: TextStyle(fontSize: 14.sp, color: theme.hintColor),
              ),
              8.verticalSpace,
              ElevatedButton(
                onPressed: () => ref.read(wishlistProvider.notifier).refresh(),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
        data: (wishlistItems) {
          if (wishlistItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded, size: 80.sp, color: theme.hintColor.withValues(alpha: 0.3)),
                  16.verticalSpace,
                  Text(
                    'webstore.wishlist.empty'.tr(context: context),
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: theme.hintColor),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.all(20.w),
            itemCount: wishlistItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final product = wishlistItems[index];
              return AppAnimation.fadeInUp(
                delay: Duration(milliseconds: index * 50),
                child: ProductCard(
                  product: product,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
