class PaymentStatusRow {
  final int id;
  final String name;
  final String? nameAr;
  final String color;
  final bool isActive;

  const PaymentStatusRow({
    required this.id,
    required this.name,
    this.nameAr,
    required this.color,
    required this.isActive,
  });

  factory PaymentStatusRow.fromJson(Map<String, dynamic> json) {
    return PaymentStatusRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      color: json['color'] as String? ?? '#000000',
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
