class OrderRow {
  final int id;
  final String customer;
  final String status;
  final String payment;
  final double total;
  final int itemsCount;
  final DateTime createdAt;

  const OrderRow({
    required this.id,
    required this.customer,
    required this.status,
    required this.payment,
    required this.total,
    required this.itemsCount,
    required this.createdAt,
  });

  String get customerName => customer;
  double get totalPrice => total;

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

  static String _parseCustomer(dynamic rawCustomer, dynamic rawCustomerName) {
    if (rawCustomer is Map) {
      final name = rawCustomer['name'] ?? 
                   rawCustomer['name_en'] ?? 
                   rawCustomer['name_ar'] ?? 
                   rawCustomer['username'] ?? 
                   rawCustomer['email'];
      if (name != null) return name.toString();
    } else if (rawCustomer is String) {
      return rawCustomer;
    }

    if (rawCustomerName is Map) {
      final name = rawCustomerName['name'] ?? 
                   rawCustomerName['name_en'] ?? 
                   rawCustomerName['name_ar'];
      if (name != null) return name.toString();
    } else if (rawCustomerName is String) {
      return rawCustomerName;
    }

    return 'Unknown';
  }

  static double _parseDoubleValue(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  static int _parseIntValue(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  factory OrderRow.fromJson(Map<String, dynamic> json) {
    return OrderRow(
      id: json['id'] as int? ?? 0,
      customer: _parseCustomer(json['customer'], json['customer_name']),
      status: _parseStringValue(json['status'], 'pending'),
      payment: _parseStringValue(json['payment'], 'cod'),
      total: _parseDoubleValue(json['total'] ?? json['total_price']),
      itemsCount: _parseIntValue(json['items_count']),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'].toString()) : DateTime.now(),
    );
  }

  OrderRow copyWith({
    int? id,
    String? customer,
    String? status,
    String? payment,
    double? total,
    int? itemsCount,
    DateTime? createdAt,
  }) {
    return OrderRow(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      status: status ?? this.status,
      payment: payment ?? this.payment,
      total: total ?? this.total,
      itemsCount: itemsCount ?? this.itemsCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}


