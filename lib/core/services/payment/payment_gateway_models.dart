/// Payment Gateway Models
///
/// `PaymentGatewayRequest` — data needed to build a checkout session
/// for Tabby / Tamara native SDKs.
/// `PaymentGatewayResult` — outcome of the in-app checkout flow.
library;

class PaymentGatewayItem {
  final String name;
  final String? sku;
  final String? imageUrl;
  final double unitPrice;
  final double discount;
  final int quantity;

  const PaymentGatewayItem({
    required this.name,
    this.sku,
    this.imageUrl,
    required this.unitPrice,
    this.discount = 0.0,
    required this.quantity,
  });
}

class PaymentGatewayRequest {
  final String gateway;
  final double totalAmount;
  final double shippingAmount;
  final double discountAmount;
  final String currency;
  final String country;
  final String orderReference;
  final String buyerName;
  final String buyerEmail;
  final String buyerPhone;
  final String? city;
  final String? address;
  final String? region;
  final List<PaymentGatewayItem> items;

  const PaymentGatewayRequest({
    required this.gateway,
    required this.totalAmount,
    required this.shippingAmount,
    required this.discountAmount,
    required this.currency,
    required this.country,
    required this.orderReference,
    required this.buyerName,
    required this.buyerEmail,
    required this.buyerPhone,
    this.city,
    this.address,
    this.region,
    this.items = const [],
  });
}

enum PaymentGatewayStatus { authorized, rejected, cancelled, failed }

class PaymentGatewayResult {
  final PaymentGatewayStatus status;
  final String? gatewayPaymentId;
  final String? gatewayOrderId;
  final String? errorMessage;

  const PaymentGatewayResult({
    required this.status,
    this.gatewayPaymentId,
    this.gatewayOrderId,
    this.errorMessage,
  });

  bool get isAuthorized => status == PaymentGatewayStatus.authorized;
}