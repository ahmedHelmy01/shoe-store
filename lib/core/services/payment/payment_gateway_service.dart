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

  /// Dispatches to the matching provider flow based on `request.gateway`.
  static Future<PaymentGatewayResult> startCheckout(
    BuildContext context,
    PaymentGatewayRequest request,
  ) {
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

      final session = await TabbySDK().createSession(
        TabbyCheckoutPayload(
          merchantCode: PaymentGatewayConfig.tabbyMerchantCode,
          lang: _isArabic(context) ? Lang.ar : Lang.en,
          payment: payment,
        ),
      );

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

      return completer.future;
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
      final fullName = _splitName(request.buyerName);
      final country = request.country.isEmpty
          ? PaymentGatewayConfig.countryCode
          : request.country;
      final currency = request.currency.isEmpty
          ? PaymentGatewayConfig.currencyCode
          : request.currency;

      await TamaraSdk.initSdk(
        PaymentGatewayConfig.tamaraAuthToken,
        PaymentGatewayConfig.tamaraSandbox
            ? PaymentGatewayConfig.tamaraApiUrlSandbox
            : PaymentGatewayConfig.tamaraApiUrlProduction,
        PaymentGatewayConfig.tamaraNotificationWebhookUrl,
        PaymentGatewayConfig.tamaraPublicKey,
        PaymentGatewayConfig.tamaraNotificationToken,
        PaymentGatewayConfig.tamaraSandbox,
      );

      await TamaraSdk.setCountry(country, currency);
      await TamaraSdk.setPaymentType('PAY_BY_INSTALMENTS');
      await TamaraSdk.setInstalments(4);
      await TamaraSdk.setLocale(isArabic ? 'ar' : 'en');
      await TamaraSdk.createOrder(request.orderReference, 'Store order');
      await TamaraSdk.setOrderNumber(request.orderReference);
      await TamaraSdk.setExpiresInMinutes(60);

      await TamaraSdk.setCustomerInfo(
        fullName.first,
        fullName.last,
        request.buyerPhone.isNotEmpty
            ? request.buyerPhone
            : '500000001',
        request.buyerEmail.isNotEmpty
            ? request.buyerEmail
            : 'customer@example.com',
        false,
      );

      await TamaraSdk.clearItem();
      for (final item in request.items) {
        await TamaraSdk.addItem(
          item.name,
          item.sku ?? item.name,
          item.sku ?? item.name,
          'physical',
          item.unitPrice,
          0,
          item.discount,
          item.quantity,
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

      await TamaraSdk.setShippingAddress(
        fullName.first,
        fullName.last,
        phone,
        addressLine1,
        '',
        country,
        region,
        city,
      );
      await TamaraSdk.setBillingAddress(
        fullName.first,
        fullName.last,
        phone,
        addressLine1,
        '',
        country,
        region,
        city,
      );

      if (request.shippingAmount > 0) {
        await TamaraSdk.setShippingAmount(request.shippingAmount);
      }
      if (request.discountAmount > 0) {
        await TamaraSdk.setDiscount(request.discountAmount, 'Discount');
      }

      final result = await TamaraSdk.paymentOrder();
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