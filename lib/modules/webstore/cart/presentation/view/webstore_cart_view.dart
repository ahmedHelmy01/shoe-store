import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/modules/webstore/cart/presentation/view_model/cart_view_model.dart';
import '../widgets/cart_item_card.dart';
import 'package:erp/core/common_widget/app_dialog/app_dialog.dart';

class WebStoreCartView extends ConsumerWidget {
  const WebStoreCartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(
        showBackButton: false,
        titleText:
            '${LocaleKeys.webstore.nav.cart.tr(context: context)} (${cartItems.length})',
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              onPressed: () {
                AppDialog.show(
                  context,
                  title: 'مسح السلة',
                  message: 'هل أنت متأكد من رغبتك في حذف جميع المنتجات من السلة؟',
                  confirmText: 'نعم، احذف',
                  cancelText: 'إلغاء',
                  onConfirm: () {
                    Navigator.pop(context);
                    cartNotifier.clearCart();
                  },
                );
              },
              icon: Icon(Icons.delete_sweep_rounded, color: Colors.red[400]),
              tooltip: 'مسح السلة',
            ),
        ],
      ),
      body: cartItems.isEmpty 
          ? _buildEmptyState(context, ref)
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return CartItemCard(
                  product: item.product,
                  quantity: item.quantity,
                  onIncrement: () =>
                      cartNotifier.incrementQuantity(item.product.id!),
                  onDecrement: () =>
                      cartNotifier.decrementQuantity(item.product.id!),
                  onRemove: () => cartNotifier.removeFromCart(item.product.id!),
                );
              },
            ),
          ),
          
          // Summary Section
          _buildSummary(context, ref),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80.sp, color: Colors.grey.withOpacity(0.5)),
          24.verticalSpace,
          Text(
            LocaleKeys.common.cart_empty.tr(context: context),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cartNotifier = ref.read(cartProvider.notifier);

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Order Details
            _summaryRow(LocaleKeys.webstore.checkout.delivery_fee.tr(context: context), '\$${cartNotifier.shipping.toStringAsFixed(0)}'),
            12.verticalSpace,
            _summaryRow(LocaleKeys.webstore.checkout.order_amount.tr(context: context), '\$${cartNotifier.subtotal.toStringAsFixed(2)}'),
            16.verticalSpace,
            const Divider(),
            16.verticalSpace,
            _summaryRow(LocaleKeys.webstore.checkout.total_amount.tr(context: context), '\$${cartNotifier.total.toStringAsFixed(2)}', isTotal: true),
            
            32.verticalSpace,
            
            // Checkout Button
            AppButton(
              onPressed: () => AppNavigator.push(context, AppRouteNames.webstoreCheckout),
              isGradient: true,
              child: Text(
                LocaleKeys.webstore.checkout.place_order.tr(context: context),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
            color: isTotal ? null : Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
