import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_snack_bar/app_snack_bar.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/modules/webstore/cart/presentation/view_model/cart_view_model.dart';
import 'package:erp/modules/webstore/profile/presentation/state/profile_state.dart';
import 'package:erp/modules/webstore/profile/presentation/view_model/profile_providers.dart';
import 'package:erp/modules/webstore/checkout/presentation/view_model/checkout_view_model.dart';
import 'package:erp/modules/webstore/checkout/presentation/state/checkout_state.dart';
import 'package:erp/modules/webstore/addresses/presentation/view_model/address_providers.dart';
import 'package:erp/modules/webstore/addresses/data/models/address_model.dart';

import 'widgets/delivery_address_section.dart';
import 'widgets/payment_method_section.dart';
import 'widgets/promo_code_section.dart';
import 'widgets/checkout_summary_section.dart';

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
      ref.read(checkoutVmProvider.notifier).calculateTotals();
    });
  }

  @override
  void dispose() {
    promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Watch cart to read notifier properties
    ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    // Fetch profile address
    final profileState = ref.watch(profileViewModelProvider);
    final userAddress = profileState is ProfileLoaded
        ? profileState.user.address ?? '123 El-Nasr St, Maadi, Cairo, Egypt'
        : '123 El-Nasr St, Maadi, Cairo, Egypt';

    final addressesAsync = ref.watch(addressesProvider);
    final addresses = addressesAsync.value ?? [];

    // Default to the default address, or first address if none is currently selected
    if (selectedAddress == null && addresses.isNotEmpty) {
      selectedAddress = addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => addresses.first,
      );
    }

    // Listen for Checkout status
    ref.listen<CheckoutState>(checkoutVmProvider, (previous, next) {
      if (next is CheckoutSuccess) {
        AppSnackBar.showSuccess(
          context,
          LocaleKeys.webstore.orders.success_order.tr(context: context),
        );
        AppNavigator.replace(context, AppRouteNames.webstoreOrderTrack);
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
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DeliveryAddressSection(
                    selectedAddress: selectedAddress,
                    userAddress: userAddress,
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
                  24.verticalSpace,
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
                  24.verticalSpace,
                  PromoCodeSection(
                    promoController: promoController,
                    selectedAddressId: selectedAddress?.id,
                    selectedPaymentId: selectedPaymentId,
                  ),
                  40.verticalSpace,
                  const CheckoutSummarySection(),
                  32.verticalSpace,
                  AppButton(
                    onPressed: () {
                      ref.read(checkoutVmProvider.notifier).confirmOrder(
                            paymentMethod: selectedPayment,
                            address: selectedAddress?.printableAddress ?? userAddress,
                            addressId: selectedAddress?.id,
                            paymentMethodId: selectedPaymentId,
                            totalAmount: cartNotifier.total,
                            couponCode: promoController.text,
                          );
                    },
                    isGradient: true,
                    child: Text(
                      LocaleKeys.webstore.checkout.place_order.tr(
                        context: context,
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  20.verticalSpace,
                ],
              ),
            ),
    );
  }
}
