/// Payment Gateway Service
///
/// Orchestrates the native in-app checkout flows for Tabby & Tamara
/// (test mode). Uses each provider's official Flutter SDK — no WebView
/// is built manually; the SDKs render their own native checkout UI.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';
import 'package:tamara_flutter_sdk/tamara_sdk.dart';

import 'package:erp/core/config/payment_gateway_config.dart';

import 'mock_checkout_page.dart';
import 'payment_gateway_models.dart';
class PaymentGatewayService {
  PaymentGatewayService._();
  static const String gatewayTabby = 'tabby';
  static const String gatewayTamara = 'tamara';
  static bool isTabby(String? code) =>
      code?.toLowerCase().contains('tabby') ?? false;
  static bool isTamara(String? code) =>
      code?.toLowerCase().contains('tamara') ?? false;
  static bool isGatewayPayment(String? code) =>
      isTabby(code) || isTamara(code);

  /// Returns `true` when the configured API keys are still placeholder
  /// values, meaning the real SDKs will fail with 401. In that case we
  /// show a mock checkout UI so the design flow can be tested end-to-end.
  static bool _useMockMode(String gateway) {
    if (isTabby(gateway)) {
      return PaymentGatewayConfig.tabbyPublicKey
          .toUpperCase()
          .contains('PLACEHOLDER');
    }
    if (isTamara(gateway)) {
      return PaymentGatewayConfig.tamaraAuthToken
          .toUpperCase()
          .contains('PLACEHOLDER');
    }
    return false;
  }

  /// Opens the [MockCheckoutPage] and returns the result chosen by the
  /// user (confirm / cancel).
  static Future<PaymentGatewayResult> _payWithMock(
    BuildContext context,
    PaymentGatewayRequest request,
  ) async {
    debugPrint('[PaymentGateway] ⚠️ MOCK MODE — placeholder keys detected '
        'for ${request.gateway}');
    final result = await Navigator.push<PaymentGatewayResult>(
      context,
      MaterialPageRoute(
        builder: (_) => MockCheckoutPage(
          gateway: request.gateway,
          totalAmount: request.totalAmount,
          shippingAmount: request.shippingAmount,
          discountAmount: request.discountAmount,
          currency: request.currency,
          items: request.items,
          buyerName: request.buyerName,
          buyerPhone: request.buyerPhone,
        ),
      ),
    );
    return result ??
        const PaymentGatewayResult(status: PaymentGatewayStatus.cancelled);
  }

  /// Dispatches to the matching provider flow based on `request.gateway`.
  /// When API keys are still placeholder values, a mock checkout UI is
  /// shown instead so the full flow can be tested during design phase.
  static Future<PaymentGatewayResult> startCheckout(
    BuildContext context,
    PaymentGatewayRequest request,
  ) {
    // ── Mock mode: placeholder keys → simulated UI ──
    if (_useMockMode(request.gateway)) {
      return _payWithMock(context, request);
    }

    final isArabic = _isArabic(context);
    if (isTabby(request.gateway)) return _payWithTabby(context, request);
    if (isTamara(request.gateway)) {
      return _payWithTamara(request, isArabic);
    }
    return Future.value(
      const PaymentGatewayResult(
        status: PaymentGatewayStatus.failed,
        errorMessage: 'Unsupported gateway',
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // TABBY
  // ═══════════════════════════════════════════════

  static Future<PaymentGatewayResult> _payWithTabby(
    BuildContext context,
    PaymentGatewayRequest request,
  ) async {
    try {
      debugPrint('[PaymentGateway] Tabby setup key=${PaymentGatewayConfig.tabbyPublicKey} '
          'sandbox=${PaymentGatewayConfig.tabbySandbox}');
      TabbySDK().setup(
        withApiKey: PaymentGatewayConfig.tabbyPublicKey,
        environment: PaymentGatewayConfig.tabbySandbox
            ? Environment.staging
            : Environment.production,
      );

      final payment = Payment(
        amount: request.totalAmount.toStringAsFixed(2),
        currency: _tabbyCurrency(request.currency),
        buyer: Buyer(
          email: request.buyerEmail.isNotEmpty
              ? request.buyerEmail
              : 'customer@example.com',
          phone: request.buyerPhone.isNotEmpty
              ? request.buyerPhone
              : '500000001',
          name: request.buyerName.isNotEmpty
              ? request.buyerName
              : 'Store Customer',
        ),
        buyerHistory: BuyerHistory(
          registeredSince: DateTime.now().toUtc().toIso8601String(),
          loyaltyLevel: 0,
          isPhoneNumberVerified: true,
          isEmailVerified: true,
        ),
        shippingAddress: ShippingAddress(
          city: request.city ?? PaymentGatewayConfig.regionName,
          address: request.address ?? PaymentGatewayConfig.storeName,
          zip: '',
        ),
        order: Order(
          referenceId: request.orderReference,
          shippingAmount: request.shippingAmount.toStringAsFixed(2),
          discountAmount: request.discountAmount > 0
              ? request.discountAmount.toStringAsFixed(2)
              : null,
          items: request.items
              .map(
                (item) => OrderItem(
                  title: item.name,
                  quantity: item.quantity,
                  unitPrice: item.unitPrice.toStringAsFixed(2),
                  category: 'general',
                  referenceId: item.sku,
                  productUrl: item.imageUrl,
                  imageUrl: item.imageUrl,
                ),
              )
              .toList(),
        ),
        orderHistory: const [],
        description: PaymentGatewayConfig.storeName,
      );

      final session = await TabbySDK()
          .createSession(
            TabbyCheckoutPayload(
              merchantCode: PaymentGatewayConfig.tabbyMerchantCode,
              lang: _isArabic(context) ? Lang.ar : Lang.en,
              payment: payment,
            ),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException(
              'Tabby session creation timed out',
            ),
          );
      debugPrint('[PaymentGateway] Tabby session status=${session.status} '
          'sessionId=${session.sessionId} paymentId=${session.paymentId} '
          'webUrl=${session.availableProducts.installments?.webUrl}');

      if (session.status == SessionStatus.rejected) {
        return const PaymentGatewayResult(
          status: PaymentGatewayStatus.rejected,
        );
      }

      if (!context.mounted) {
        return const PaymentGatewayResult(
          status: PaymentGatewayStatus.cancelled,
        );
      }

      final webUrl =
          session.availableProducts.installments?.webUrl ?? session.paymentId;
      final completer = Completer<PaymentGatewayResult>();

      TabbyWebView.showWebView(
        context: context,
        webUrl: webUrl,
        onResult: (resultCode) {
          switch (resultCode) {
            case WebViewResult.authorized:
              completer.complete(
                PaymentGatewayResult(
                  status: PaymentGatewayStatus.authorized,
                  gatewayPaymentId: session.paymentId,
                  gatewayOrderId: session.sessionId,
                ),
              );
            case WebViewResult.rejected:
              completer.complete(
                const PaymentGatewayResult(
                  status: PaymentGatewayStatus.rejected,
                ),
              );
            case WebViewResult.expired:
            case WebViewResult.close:
              completer.complete(
                const PaymentGatewayResult(
                  status: PaymentGatewayStatus.cancelled,
                ),
              );
          }
        },
      );

      // Safety net: if the sheet is dismissed (back button/barrier) the SDK
      // never fires onResult, so the future would hang forever.
      return completer.future.timeout(
        const Duration(minutes: 10),
        onTimeout: () => const PaymentGatewayResult(
          status: PaymentGatewayStatus.cancelled,
        ),
      );
    } catch (e) {
      return PaymentGatewayResult(
        status: PaymentGatewayStatus.failed,
        errorMessage: e.toString(),
      );
    }
  }

  static Currency _tabbyCurrency(String code) {
    switch (code.toUpperCase()) {
      case 'AED':
        return Currency.aed;
      case 'SAR':
        return Currency.sar;
      case 'KWD':
        return Currency.kwd;
      case 'BHD':
        return Currency.bhd;
      case 'QAR':
        return Currency.qar;
      default:
        return Currency.sar;
    }
  }

  // ═══════════════════════════════════════════════
  // TAMARA
  // ═══════════════════════════════════════════════

  static Future<PaymentGatewayResult> _payWithTamara(
    PaymentGatewayRequest request,
    bool isArabic,
  ) async {
    try {
      debugPrint('[PaymentGateway] Tamara init token=${PaymentGatewayConfig.tamaraAuthToken} '
          'sandbox=${PaymentGatewayConfig.tamaraSandbox}');
      final fullName = _splitName(request.buyerName);
      final country = request.country.isEmpty
          ? PaymentGatewayConfig.countryCode
          : request.country;
      final currency = request.currency.isEmpty
          ? PaymentGatewayConfig.currencyCode
          : request.currency;

      // Guard: the native buildOrder() throws InvalidItemException on an
      // empty item list, which crashes the whole app (the plugin does not
      // catch it). Fail gracefully instead.
      if (request.items.isEmpty) {
        return const PaymentGatewayResult(
          status: PaymentGatewayStatus.failed,
          errorMessage: 'Cart is empty',
        );
      }

      // IMPORTANT: the Tamara Android plugin never completes the platform
      // channel result for these setup calls (only paymentOrder responds),
      // so awaiting them hangs forever. They run synchronously and in
      // order on the native main thread, so fire-and-forget is safe.
      _callTamara(
        TamaraSdk.initSdk(
          PaymentGatewayConfig.tamaraAuthToken,
          PaymentGatewayConfig.tamaraSandbox
              ? PaymentGatewayConfig.tamaraApiUrlSandbox
              : PaymentGatewayConfig.tamaraApiUrlProduction,
          PaymentGatewayConfig.tamaraNotificationWebhookUrl,
          PaymentGatewayConfig.tamaraPublicKey,
          PaymentGatewayConfig.tamaraNotificationToken,
          PaymentGatewayConfig.tamaraSandbox,
        ),
        'initSdk',
      );
      // createOrder MUST come first: the native SDK throws InvalidState
      // ("Please call createOrder before add data") for every other set*
      // call until the order session begins, and createOrder resets the
      // order object, wiping anything set before it.
      _callTamara(
        TamaraSdk.createOrder(request.orderReference, 'Store order'),
        'createOrder',
      );
      _callTamara(
        TamaraSdk.setCountry(country, currency),
        'setCountry',
      );
      _callTamara(
        TamaraSdk.setPaymentType('PAY_BY_INSTALMENTS'),
        'setPaymentType',
      );
      _callTamara(TamaraSdk.setInstalments(4), 'setInstalments');
      _callTamara(TamaraSdk.setLocale(isArabic ? 'ar' : 'en'), 'setLocale');
      _callTamara(
        TamaraSdk.setOrderNumber(request.orderReference),
        'setOrderNumber',
      );
      _callTamara(
        TamaraSdk.setExpiresInMinutes(60),
        'setExpiresInMinutes',
      );

      _callTamara(
        TamaraSdk.setCustomerInfo(
          fullName.first,
          fullName.last,
          request.buyerPhone.isNotEmpty
              ? request.buyerPhone
              : '500000001',
          request.buyerEmail.isNotEmpty
              ? request.buyerEmail
              : 'customer@example.com',
          false,
        ),
        'setCustomerInfo',
      );

      _callTamara(TamaraSdk.clearItem(), 'clearItem');
      for (final item in request.items) {
        _callTamara(
          TamaraSdk.addItem(
            item.name,
            item.sku ?? item.name,
            item.sku ?? item.name,
            'physical',
            item.unitPrice,
            0,
            item.discount,
            item.quantity,
          ),
          'addItem(${item.name})',
        );
      }

      final phone = request.buyerPhone.isNotEmpty
          ? request.buyerPhone
          : '500000001';
      final addressLine1 =
          request.address ?? PaymentGatewayConfig.storeName;
      final city = request.city ?? PaymentGatewayConfig.regionName;
      final region =
          request.region ?? PaymentGatewayConfig.regionName;

      _callTamara(
        TamaraSdk.setShippingAddress(
          fullName.first,
          fullName.last,
          phone,
          addressLine1,
          '',
          country,
          region,
          city,
        ),
        'setShippingAddress',
      );
      _callTamara(
        TamaraSdk.setBillingAddress(
          fullName.first,
          fullName.last,
          phone,
          addressLine1,
          '',
          country,
          region,
          city,
        ),
        'setBillingAddress',
      );

      // Always set shipping amount: Tamara's native validateData() throws
      // InvalidShippingFeeException when it stays null (e.g. free shipping).
      _callTamara(
        TamaraSdk.setShippingAmount(request.shippingAmount),
        'setShippingAmount',
      );
      if (request.discountAmount > 0) {
        _callTamara(
          TamaraSdk.setDiscount(request.discountAmount, 'Discount'),
          'setDiscount',
        );
      }

      // Only paymentOrder() responds on the channel. Its native activity
      // result can also be lost (back button/crash), leaving the future
      // pending forever — time out so the UI never stays stuck loading.
      debugPrint('[PaymentGateway] Tamara calling paymentOrder...');
      final result = await TamaraSdk.paymentOrder().timeout(
            const Duration(minutes: 10),
            onTimeout: () => throw TimeoutException(
              'Tamara payment timed out',
            ),
          );
      debugPrint('[PaymentGateway] Tamara paymentOrder result: $result');
      final trimmed = result.trim();

      if (trimmed == 'Payment canceled' ||
          trimmed == 'Payment cancelled') {
        return const PaymentGatewayResult(
          status: PaymentGatewayStatus.cancelled,
        );
      }

      final dynamic decoded = jsonDecode(trimmed);
      if (decoded is Map<String, dynamic>) {
        final orderId = decoded['order_id']?.toString();
        return PaymentGatewayResult(
          status: PaymentGatewayStatus.authorized,
          gatewayOrderId: orderId,
          gatewayPaymentId: orderId,
        );
      }

      return PaymentGatewayResult(
        status: PaymentGatewayStatus.failed,
        errorMessage: trimmed,
      );
    } catch (e) {
      return PaymentGatewayResult(
        status: PaymentGatewayStatus.failed,
        errorMessage: e.toString(),
      );
    }
  }

  // ═══════════════════════════════════════════════
  // UTILS
  // ═══════════════════════════════════════════════

  /// Fires a Tamara setup call without awaiting. The Android plugin never
  /// responds to these calls (only paymentOrder does), so awaiting them
  /// would hang forever; they are processed in order on the native side.
  static void _callTamara(Future<void> future, String label) {
    unawaited(future.catchError((Object e) {
      debugPrint('[PaymentGateway] Tamara $label error: $e');
    }));
  }

  static String buildOrderReference() {
    final rand = Random().nextInt(0x7fffffff);
    return '${DateTime.now().millisecondsSinceEpoch}_$rand';
  }

  static ({String first, String last}) _splitName(String fullName) {
    final parts =
        fullName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return (first: '', last: '');
    if (parts.length == 1) return (first: parts.first, last: '');
    return (first: parts.first, last: parts.skip(1).join(' '));
  }

  static bool _isArabic(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode.toLowerCase() == 'ar';
  }
}