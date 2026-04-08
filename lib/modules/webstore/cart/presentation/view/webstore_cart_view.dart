import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/home/data/models/webstore_mock_data.dart';
import 'package:erp/core/router/app_navigator.dart';
import '../widgets/cart_item_card.dart';

class WebStoreCartView extends StatefulWidget {
  const WebStoreCartView({super.key});

  @override
  State<WebStoreCartView> createState() => _WebStoreCartViewState();
}

class _WebStoreCartViewState extends State<WebStoreCartView> {
  // Mock Cart State
  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = [
      {'product': WebStoreMockData.featuredProducts[0], 'quantity': 1},
      {'product': WebStoreMockData.featuredProducts[1], 'quantity': 1},
      {'product': WebStoreMockData.featuredProducts[2], 'quantity': 1},
    ];
  }

  double get subtotal => cartItems.fold(
      0, (sum, item) => sum + (item['product'] as MockProduct).price * item['quantity']);
  double get shipping => 25.0;
  double get tax => 0.0;
  double get total => subtotal + shipping + tax;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(
        titleText: 'Cart (${cartItems.length})',
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Edit',
              style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return CartItemCard(
                  product: item['product'],
                  quantity: item['quantity'],
                  onIncrement: () => setState(() => item['quantity']++),
                  onDecrement: () => setState(() {
                    if (item['quantity'] > 1) item['quantity']--;
                  }),
                  onRemove: () => setState(() => cartItems.removeAt(index)),
                );
              },
            ),
          ),
          
          // Summary Section
          _buildSummary(context),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
            _summaryRow('Shipping', '\$${shipping.toStringAsFixed(0)}'),
            12.verticalSpace,
            _summaryRow('Tax', '\$${tax.toStringAsFixed(0)}'),
            12.verticalSpace,
            _summaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
            16.verticalSpace,
            const Divider(),
            16.verticalSpace,
            _summaryRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
            
            32.verticalSpace,
            
            // Checkout Button
            AppButton(
              onPressed: () => AppNavigator.push(context, AppRouteNames.webstoreCheckout),
              isGradient: true,
              child: Text(
                'Checkout',
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
