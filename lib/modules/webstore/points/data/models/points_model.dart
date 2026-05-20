class PointTransaction {
  final int id;
  final String title;
  final String date;
  final int points;
  final bool isEarned;

  PointTransaction({
    required this.id,
    required this.title,
    required this.date,
    required this.points,
    required this.isEarned,
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
    );
  }
}

class PointsModel {
  final int balance;
  final List<PointTransaction> transactions;

  PointsModel({required this.balance, required this.transactions});

  factory PointsModel.fromJson(Map<String, dynamic> json) {
    final balanceVal = json['points_balance'] ?? json['balance'] ?? json['points'] ?? json['total_points'] ?? 0;
    final transList = (json['transactions'] as List?) ?? (json['data'] as List?) ?? [];
    return PointsModel(
      balance: balanceVal is int ? balanceVal : (double.tryParse(balanceVal.toString())?.toInt() ?? int.tryParse(balanceVal.toString()) ?? 0),
      transactions: transList
          .whereType<Map<String, dynamic>>()
          .map((e) => PointTransaction.fromJson(e))
          .toList(),
    );
  }
}
