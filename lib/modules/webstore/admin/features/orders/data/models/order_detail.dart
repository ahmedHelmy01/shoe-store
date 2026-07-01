class OrderDetail {
  final int id;
  final String orderNumber;
  final OrderStatusInfo status;
  final PaymentStatusInfo? paymentStatus;
  final PaymentMethodInfo? paymentMethod;
  final List<OrderItemDetail> items;
  final AddressDetail? address;
  final String? couponCode;
  final String subtotal;
  final String discountAmount;
  final String shippingCost;
  final String taxAmount;
  final String total;
  final String? notes;
  final String? cancelledAt;
  final String? cancelledReason;
  final String? shippedAt;
  final String? deliveredAt;
  final String createdAt;
  final String updatedAt;

  OrderDetail({
    required this.id,
    required this.orderNumber,
    required this.status,
    this.paymentStatus,
    this.paymentMethod,
    required this.items,
    this.address,
    this.couponCode,
    required this.subtotal,
    required this.discountAmount,
    required this.shippingCost,
    required this.taxAmount,
    required this.total,
    this.notes,
    this.cancelledAt,
    this.cancelledReason,
    this.shippedAt,
    this.deliveredAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'] as int? ?? 0,
      orderNumber: json['order_number'] as String? ?? '',
      status: json['status'] is Map
          ? OrderStatusInfo.fromJson(json['status'] as Map<String, dynamic>)
          : OrderStatusInfo(id: 0, name: ''),
      paymentStatus: json['payment_status'] is Map
          ? PaymentStatusInfo.fromJson(json['payment_status'] as Map<String, dynamic>)
          : null,
      paymentMethod: json['payment_method'] is Map
          ? PaymentMethodInfo.fromJson(json['payment_method'] as Map<String, dynamic>)
          : null,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      address: json['address'] is Map
          ? AddressDetail.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      couponCode: json['coupon_code'] as String?,
      subtotal: json['subtotal'] as String? ?? '0',
      discountAmount: json['discount_amount'] as String? ?? '0',
      shippingCost: json['shipping_cost'] as String? ?? '0',
      taxAmount: json['tax_amount'] as String? ?? '0',
      total: json['total'] as String? ?? '0',
      notes: json['notes'] as String?,
      cancelledAt: json['cancelled_at'] as String?,
      cancelledReason: json['cancelled_reason'] as String?,
      shippedAt: json['shipped_at'] as String?,
      deliveredAt: json['delivered_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}

class OrderStatusInfo {
  final int id;
  final String name;
  final String? color;

  OrderStatusInfo({required this.id, required this.name, this.color});

  factory OrderStatusInfo.fromJson(Map<String, dynamic> json) {
    return OrderStatusInfo(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      color: json['color'] as String?,
    );
  }
}

class PaymentStatusInfo {
  final int id;
  final String name;

  PaymentStatusInfo({required this.id, required this.name});

  factory PaymentStatusInfo.fromJson(Map<String, dynamic> json) {
    return PaymentStatusInfo(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

class PaymentMethodInfo {
  final int id;
  final String name;
  final String? type;

  PaymentMethodInfo({required this.id, required this.name, this.type});

  factory PaymentMethodInfo.fromJson(Map<String, dynamic> json) {
    return PaymentMethodInfo(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      type: json['type'] as String?,
    );
  }
}

class OrderItemDetail {
  final int id;
  final int? productId;
  final int? productVariantId;
  final String productName;
  final String? productNameAr;
  final int quantity;
  final String unitPrice;
  final String discount;
  final String total;

  OrderItemDetail({
    required this.id,
    this.productId,
    this.productVariantId,
    required this.productName,
    this.productNameAr,
    required this.quantity,
    required this.unitPrice,
    required this.discount,
    required this.total,
  });

  factory OrderItemDetail.fromJson(Map<String, dynamic> json) {
    return OrderItemDetail(
      id: json['id'] as int? ?? 0,
      productId: json['product_id'] as int?,
      productVariantId: json['product_variant_id'] as int?,
      productName: json['product_name'] as String? ?? '',
      productNameAr: json['product_name_ar'] as String?,
      quantity: json['quantity'] as int? ?? 0,
      unitPrice: json['unit_price'] as String? ?? '0',
      discount: json['discount'] as String? ?? '0',
      total: json['total'] as String? ?? '0',
    );
  }
}

class AddressDetail {
  final int id;
  final String? name;
  final String? mobile;
  final int? governorateId;
  final GovernorateInfo? governorate;
  final int? cityId;
  final CityInfo? city;
  final String? area;
  final String? block;
  final String? street;
  final String? building;
  final String? floor;
  final String? apartment;
  final String? code;
  final String? addressDetails;
  final String? notes;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  AddressDetail({
    required this.id,
    this.name,
    this.mobile,
    this.governorateId,
    this.governorate,
    this.cityId,
    this.city,
    this.area,
    this.block,
    this.street,
    this.building,
    this.floor,
    this.apartment,
    this.code,
    this.addressDetails,
    this.notes,
    this.latitude,
    this.longitude,
    required this.isDefault,
  });

  factory AddressDetail.fromJson(Map<String, dynamic> json) {
    return AddressDetail(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String?,
      mobile: json['mobile'] as String?,
      governorateId: json['governorate_id'] as int?,
      governorate: json['governorate'] is Map
          ? GovernorateInfo.fromJson(json['governorate'] as Map<String, dynamic>)
          : null,
      cityId: json['city_id'] as int?,
      city: json['city'] is Map
          ? CityInfo.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      area: json['area'] as String?,
      block: json['block'] as String?,
      street: json['street'] as String?,
      building: json['building'] as String?,
      floor: json['floor'] as String?,
      apartment: json['apartment'] as String?,
      code: json['code'] as String?,
      addressDetails: json['address_details'] as String?,
      notes: json['notes'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isDefault: json['is_default'] as bool? ?? false,
    );
  }
}

class GovernorateInfo {
  final int id;
  final int? countryId;
  final String name;
  final String? nameEn;
  final String? nameAr;

  GovernorateInfo({required this.id, this.countryId, required this.name, this.nameEn, this.nameAr});

  factory GovernorateInfo.fromJson(Map<String, dynamic> json) {
    return GovernorateInfo(
      id: json['id'] as int? ?? 0,
      countryId: json['country_id'] as int?,
      name: json['name'] as String? ?? '',
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
    );
  }
}

class CityInfo {
  final int id;
  final String name;
  final String? nameEn;
  final String? nameAr;
  final int? governorateId;
  final String? shippingCost;
  final bool isActive;

  CityInfo({
    required this.id,
    required this.name,
    this.nameEn,
    this.nameAr,
    this.governorateId,
    this.shippingCost,
    required this.isActive,
  });

  factory CityInfo.fromJson(Map<String, dynamic> json) {
    return CityInfo(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
      governorateId: json['governorate_id'] as int?,
      shippingCost: json['shipping_cost'] as String?,
      isActive: json['is_active'] as bool? ?? false,
    );
  }
}
