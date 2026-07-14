class AdminPointTransaction {
  final int id;
  final int points;
  final String type;
  final String? reason;
  final String? orderId;
  final String createdAt;
  final String? adjustedBy;

  const AdminPointTransaction({
    required this.id,
    required this.points,
    required this.type,
    this.reason,
    this.orderId,
    required this.createdAt,
    this.adjustedBy,
  });

  factory AdminPointTransaction.fromJson(Map<String, dynamic> json) {
    return AdminPointTransaction(
      id: json['id'] as int? ?? 0,
      points: json['points'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      reason: json['reason'] as String?,
      orderId: json['order_id']?.toString(),
      createdAt: json['created_at'] as String? ?? '',
      adjustedBy: json['adjusted_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
      'type': type,
      'reason': reason,
      'order_id': orderId,
      'created_at': createdAt,
      'adjusted_by': adjustedBy,
    };
  }
}

class AdminCustomerPointsModel {
  final int customerId;
  final String customerName;
  final int balance;
  final int totalEarned;
  final int totalUsed;
  final int totalExpired;
  final int totalAdjusted;
  final String? lastEarnedDate;
  final String? lastUsedDate;
  final String? nearestExpiryDate;
  final double? monetaryValue;
  final List<AdminPointTransaction> transactions;

  const AdminCustomerPointsModel({
    required this.customerId,
    required this.customerName,
    required this.balance,
    required this.totalEarned,
    required this.totalUsed,
    required this.totalExpired,
    required this.totalAdjusted,
    this.lastEarnedDate,
    this.lastUsedDate,
    this.nearestExpiryDate,
    this.monetaryValue,
    required this.transactions,
  });

  factory AdminCustomerPointsModel.fromJson(Map<String, dynamic> json) {
    final transactionsList = (json['transactions'] as List<dynamic>?)
            ?.map((e) =>
                AdminPointTransaction.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];
    return AdminCustomerPointsModel(
      customerId: json['customer_id'] as int? ?? json['id'] as int? ?? 0,
      customerName:
          json['customer_name'] as String? ?? json['name'] as String? ?? '',
      balance: json['balance'] as int? ?? json['points_balance'] as int? ?? 0,
      totalEarned: json['total_earned'] as int? ?? 0,
      totalUsed: json['total_used'] as int? ?? 0,
      totalExpired: json['total_expired'] as int? ?? 0,
      totalAdjusted: json['total_adjusted'] as int? ?? 0,
      lastEarnedDate: json['last_earned_date'] as String?,
      lastUsedDate: json['last_used_date'] as String?,
      nearestExpiryDate: json['nearest_expiry_date'] as String?,
      monetaryValue: (json['monetary_value'] as num?)?.toDouble(),
      transactions: transactionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'customer_name': customerName,
      'balance': balance,
      'total_earned': totalEarned,
      'total_used': totalUsed,
      'total_expired': totalExpired,
      'total_adjusted': totalAdjusted,
      'last_earned_date': lastEarnedDate,
      'last_used_date': lastUsedDate,
      'nearest_expiry_date': nearestExpiryDate,
      'monetary_value': monetaryValue,
      'transactions': transactions.map((e) => e.toJson()).toList(),
    };
  }
}
