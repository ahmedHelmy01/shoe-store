class OrderRow {
  final int id;
  final String orderNumber;
  final String status;
  final String? statusColor;
  final String payment;
  final double total;
  final int itemsCount;
  final DateTime createdAt;

  const OrderRow({
    required this.id,
    required this.orderNumber,
    required this.status,
    this.statusColor,
    required this.payment,
    required this.total,
    required this.itemsCount,
    required this.createdAt,
  });

  String get customerName => orderNumber;
  double get totalPrice => total;

  static double _parseDoubleValue(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseIntValue(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _parseStringValue(dynamic value, String defaultValue) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    if (value is Map) {
      final candidate = value['name'] ??
          value['name_en'] ??
          value['name_ar'] ??
          value['title'] ??
          value['code'] ??
          value['status'] ??
          value['label'];
      if (candidate != null) return candidate.toString();
    }
    return value.toString();
  }

  factory OrderRow.fromJson(Map<String, dynamic> json) {
    // Extract status color from the status map if available
    String? statusColor;
    final rawStatus = json['status'];
    if (rawStatus is Map) {
      statusColor = rawStatus['color']?.toString();
    }

    return OrderRow(
      id: json['id'] as int? ?? 0,
      orderNumber: json['order_number'] as String? ?? '#${json['id'] ?? 0}',
      status: _parseStringValue(json['status'], 'pending'),
      statusColor: statusColor,
      payment: _parseStringValue(json['payment_method'] ?? json['payment'], 'cod'),
      total: _parseDoubleValue(json['total'] ?? json['total_price']),
      itemsCount: _parseIntValue(json['items_count'] ?? (json['items'] is List ? (json['items'] as List).length : 0)),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'].toString()) : DateTime.now(),
    );
  }

  OrderRow copyWith({
    int? id,
    String? orderNumber,
    String? status,
    String? statusColor,
    String? payment,
    double? total,
    int? itemsCount,
    DateTime? createdAt,
  }) {
    return OrderRow(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
      payment: payment ?? this.payment,
      total: total ?? this.total,
      itemsCount: itemsCount ?? this.itemsCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}


