class UserRow {
  final int id;
  final String name;
  final String? email;
  final String? mobile;
  final int ordersCount;
  final double totalSpent;
  final DateTime? createdAt;
  final bool isActive;

  const UserRow({
    required this.id,
    required this.name,
    this.email,
    this.mobile,
    this.ordersCount = 0,
    this.totalSpent = 0.0,
    this.createdAt,
    this.isActive = true,
  });

  factory UserRow.fromJson(Map<String, dynamic> json) {
    return UserRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      ordersCount: (json['orders_count'] ?? json['total_orders'] ?? 0) as int,
      totalSpent: (json['total_spent'] ?? 0.0).toDouble(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      isActive: (json['is_active'] ?? true) == true || (json['is_active'] == 1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'orders_count': ordersCount,
      'total_spent': totalSpent,
      'created_at': createdAt?.toIso8601String(),
      'is_active': isActive,
    };
  }
}
