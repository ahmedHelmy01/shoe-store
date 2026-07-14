class PointTransaction {
  final int id;
  final String title;
  final String date;
  final int points;
  final bool isEarned;
  final String? type;
  final String? orderId;
  final String? expiryDate;

  PointTransaction({
    required this.id,
    required this.title,
    required this.date,
    required this.points,
    required this.isEarned,
    this.type,
    this.orderId,
    this.expiryDate,
  });

  factory PointTransaction.fromJson(Map<String, dynamic> json) {
    final pts = json['points'] ?? 0;
    final intPts = pts is int ? pts : (double.tryParse(pts.toString())?.toInt() ?? int.tryParse(pts.toString()) ?? 0);
    return PointTransaction(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? json['description'] as String? ?? json['reason'] as String? ?? '',
      date: json['created_at'] as String? ?? json['date'] as String? ?? '',
      points: intPts.abs(),
      isEarned: intPts >= 0 || (json['is_earned'] as bool? ?? true),
      type: json['type'] as String?,
      orderId: json['order_id']?.toString(),
      expiryDate: json['expiry_date'] as String?,
    );
  }
}

class PointsModel {
  final int balance;
  final int totalEarned;
  final int totalUsed;
  final int totalExpired;
  final double? monetaryValue;
  final String? nearestExpiryDate;
  final List<PointTransaction> transactions;

  PointsModel({
    required this.balance,
    required this.transactions,
    this.totalEarned = 0,
    this.totalUsed = 0,
    this.totalExpired = 0,
    this.monetaryValue,
    this.nearestExpiryDate,
  });

  factory PointsModel.fromJson(Map<String, dynamic> json) {
    final balanceVal = json['points_balance'] ?? json['balance'] ?? json['points'] ?? json['total_points'] ?? 0;
    final transList = (json['transactions'] as List?) ?? (json['data'] as List?) ?? [];
    return PointsModel(
      balance: balanceVal is int ? balanceVal : (double.tryParse(balanceVal.toString())?.toInt() ?? int.tryParse(balanceVal.toString()) ?? 0),
      totalEarned: json['total_earned'] as int? ?? 0,
      totalUsed: json['total_used'] as int? ?? 0,
      totalExpired: json['total_expired'] as int? ?? 0,
      monetaryValue: (json['monetary_value'] as num?)?.toDouble(),
      nearestExpiryDate: json['nearest_expiry_date'] as String?,
      transactions: transList
          .whereType<Map<String, dynamic>>()
          .map((e) => PointTransaction.fromJson(e))
          .toList(),
    );
  }
}
