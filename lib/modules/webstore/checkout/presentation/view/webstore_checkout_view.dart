import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_snack_bar/app_snack_bar.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/modules/webstore/cart/presentation/view_model/cart_view_model.dart';
import 'package:erp/modules/webstore/checkout/presentation/view_model/checkout_view_model.dart';
import 'package:erp/modules/webstore/checkout/presentation/state/checkout_state.dart';
import 'package:erp/modules/webstore/addresses/data/models/address_model.dart';
import 'package:erp/modules/webstore/addresses/presentation/view_model/address_providers.dart';
import 'package:erp/modules/webstore/addresses/presentation/utils/address_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/modules/webstore/points/presentation/view_model/points_providers.dart';

import 'widgets/delivery_address_section.dart';
import 'widgets/payment_method_section.dart';
import 'widgets/promo_code_section.dart';
import 'widgets/checkout_summary_section.dart';
import 'widgets/points_redemption_section.dart';

class WebStoreCheckoutView extends ConsumerStatefulWidget {
  const WebStoreCheckoutView({super.key});

  @override
  ConsumerState<WebStoreCheckoutView> createState() =>
      _WebStoreCheckoutViewState();
}

class _WebStoreCheckoutViewState extends ConsumerState<WebStoreCheckoutView> {
  String selectedPayment = 'visa';
  final TextEditingController promoController = TextEditingController();
  
  AddressModel? selectedAddress;
  int? selectedPaymentId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(checkoutVmProvider.notifier).validateCart();
    });
  }

  @override
  void dispose() {
    promoController.dispose();
    super.dispose();
  }

  void _showOrderSuccessDialog(BuildContext context, Map<String, dynamic> data) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final order = data['data'] ?? data;
    final orderNumber = order['order_number'] ?? '#---';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: isDark ? const Color(0xFF13233D) : Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle_rounded,
                    color: Colors.green, size: 60.sp),
              ),
              24.verticalSpace,
              Text(
                LocaleKeys.webstore.checkout.order_executed_successfully.tr(context: context),
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black87),
              ),
              12.verticalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  LocaleKeys.webstore.checkout.order_number_msg.tr(context: context, args: ['$orderNumber']),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.grey[800],
                  ),
                ),
              ),
              24.verticalSpace,
              Text(
                LocaleKeys.webstore.checkout.thanks_for_shopping_track_order.tr(context: context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.5,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
              32.verticalSpace,
              AppButton(
                onPressed: () {
                  Navigator.pop(context);
                  AppNavigator.replace(
                    context,
                    AppRouteNames.webstoreOrderTrack,
                    arguments: {
                      'order_id': order['id'],
                      'order_number': orderNumber,
                    },
                  );
                },
                isGradient: true,
                child: Text(
                  LocaleKeys.webstore.checkout.track_order_btn.tr(context: context),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              12.verticalSpace,
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  AppNavigator.replace(context, AppRouteNames.webstoreMain);
                },
                child: Text(
                  LocaleKeys.webstore.checkout.back_to_home.tr(context: context),
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Watch cart to read notifier properties
    ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);


    final addressesAsync = ref.watch(addressesProvider);
    final addresses = addressesAsync.value ?? [];

    // Listen for addresses loading to select default address and calculate totals
    ref.listen<AsyncValue<List<AddressModel>>>(addressesProvider, (previous, next) {
      if (next.hasValue && selectedAddress == null) {
        final list = next.value ?? [];
        if (list.isNotEmpty) {
          final defaultAddr = list.firstWhere(
            (a) => a.isDefault,
            orElse: () => list.first,
          );
          setState(() {
            selectedAddress = defaultAddr;
          });
          ref.read(checkoutVmProvider.notifier).calculateTotals(
                addressId: defaultAddr.id,
                couponCode: promoController.text,
              );
        }
      }
    });

    // If addresses loaded before the listener was registered (e.g. cached),
    // select default address and trigger calculation via post-frame callback
    if (selectedAddress == null && addresses.isNotEmpty) {
      final defaultAddr = addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => addresses.first,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && selectedAddress == null) {
          setState(() {
            selectedAddress = defaultAddr;
          });
          ref.read(checkoutVmProvider.notifier).calculateTotals(
                addressId: defaultAddr.id,
              );
        }
      });
    }

    // Listen for Checkout status
    ref.listen<CheckoutState>(checkoutVmProvider, (previous, next) {
      if (next is CheckoutSuccess) {
        // Invalidate points so loyalty/summary re-fetches with fresh data
        ref.invalidate(pointsProvider);
        _showOrderSuccessDialog(context, next.orderResult);
      } else if (next is CheckoutError) {
        AppSnackBar.showError(context, next.message);
      }
    });

    final checkoutState = ref.watch(checkoutVmProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(
        titleText: LocaleKeys.webstore.checkout.title.tr(context: context),
      ),
      body: checkoutState is CheckoutSubmitting
          ? const Center(child: CircularProgressIndicator.adaptive())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DeliveryAddressSection(
                    selectedAddress: selectedAddress,
                    addresses: addresses,
                    onAddressSelected: (addr) {
                      setState(() {
                        selectedAddress = addr;
                      });
                      ref.read(checkoutVmProvider.notifier).calculateTotals(
                            addressId: addr.id,
                            couponCode: promoController.text,
                          );
                    },
                  ),
                  20.verticalSpace,
                  PaymentMethodSection(
                    selectedPaymentId: selectedPaymentId,
                    selectedPayment: selectedPayment,
                    onPaymentSelected: (id, code) {
                      setState(() {
                        selectedPaymentId = id;
                        selectedPayment = code;
                      });
                      ref.read(checkoutVmProvider.notifier).calculateTotals(
                            addressId: selectedAddress?.id,
                            paymentMethodId: id,
                            couponCode: promoController.text,
                          );
                    },
                  ),
                  20.verticalSpace,
                  PromoCodeSection(
                    promoController: promoController,
                    selectedAddressId: selectedAddress?.id,
                    selectedPaymentId: selectedPaymentId,
                  ),
                  20.verticalSpace,
                  PointsRedemptionSection(
                    addressId: selectedAddress?.id,
                    paymentMethodId: selectedPaymentId,
                    couponCode: promoController.text,
                  ),
                  20.verticalSpace,
                  const CheckoutSummarySection(),
                  24.verticalSpace,
                ],
              ),
            ),
      bottomNavigationBar: checkoutState is CheckoutSubmitting
          ? null
          : Container(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: AppButton(
                  onPressed: selectedAddress == null ? null : () {
                    ref.read(checkoutVmProvider.notifier).confirmOrder(
                          paymentMethod: selectedPayment,
                          address: selectedAddress!.localizedPrintableAddress(context),
                          addressId: selectedAddress!.id,
                          paymentMethodId: selectedPaymentId,
                          totalAmount: cartNotifier.total,
                          couponCode: promoController.text,
                        );
                  },
                  isGradient: true,
                  child: Text(
                    LocaleKeys.webstore.checkout.place_order.tr(context: context,),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
