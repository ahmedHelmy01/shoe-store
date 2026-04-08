import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/product_card.dart';

class WebStoreWishlistView extends StatefulWidget {
  const WebStoreWishlistView({super.key});

  @override
  State<WebStoreWishlistView> createState() => _WebStoreWishlistViewState();
}

class _WebStoreWishlistViewState extends State<WebStoreWishlistView> {
  late List<WebStoreProduct> wishlistItems;

  @override
  void initState() {
    super.initState();
    wishlistItems = [
      const WebStoreProduct(
        id: 1,
        name: 'NIKE Air Max 2090',
        price: 450.0,
        oldPrice: 500.0,
        image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=200&auto=format&fit=crop',
        stock: 10,
        rating: 4.8,
        reviewsCount: 124,
      ),
      const WebStoreProduct(
        id: 2,
        name: 'Sony WH-1000XM4',
        price: 890.0,
        image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=200&auto=format&fit=crop',
        stock: 5,
        rating: 4.9,
        reviewsCount: 312,
      ),
    ];
  }

  void _removeItem(int index) {
    setState(() {
      wishlistItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(titleText: 'webstore.more.wishlist'.tr()),
      body: wishlistItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded, size: 80.sp, color: theme.hintColor.withValues(alpha: 0.3)),
                  16.verticalSpace,
                  Text(
                    'webstore.wishlist.empty'.tr(),
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: theme.hintColor),
                  ),
                ],
              ),
            )
          : GridView.builder(
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
                  child: Stack(
                    children: [
                      ProductCard(
                        product: product,
                        onAddToCart: () {
                          // Handle add to cart
                        },
                      ),
                      Positioned(
                        top: 8.h,
                        left: 8.w, // Position opposite to typical favorite button
                        child: GestureDetector(
                          onTap: () => _removeItem(index),
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                )
                              ],
                            ),
                            child: Icon(Icons.close_rounded, size: 16.sp, color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
