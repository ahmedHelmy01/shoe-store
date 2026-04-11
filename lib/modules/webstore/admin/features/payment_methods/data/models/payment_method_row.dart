class PaymentMethodRow {
  final int id;
  final String title;
  final String? titleAr;
  final String type;
  final bool isActive;

  const PaymentMethodRow({
    required this.id,
    required this.title,
    this.titleAr,
    required this.type,
    required this.isActive,
  });

  factory PaymentMethodRow.fromJson(Map<String, dynamic> json) {
    return PaymentMethodRow(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String?,
      type: json['type'] as String? ?? 'cod',
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
