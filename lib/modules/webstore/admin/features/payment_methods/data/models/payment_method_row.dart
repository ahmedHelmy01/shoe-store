class PaymentMethodRow {
  final int id;
  final String title;
  final String? titleAr;
  final String? description;
  final String? descriptionAr;
  final String type;
  final bool isActive;

  const PaymentMethodRow({
    required this.id,
    required this.title,
    this.titleAr,
    this.description,
    this.descriptionAr,
    required this.type,
    required this.isActive,
  });

  // Alias for title to resolve form mismatch
  String get name => title;

  factory PaymentMethodRow.fromJson(Map<String, dynamic> json) {
    return PaymentMethodRow(
      id: json['id'] as int? ?? 0,
      title: (json['title'] ?? json['name']) as String? ?? '',
      titleAr: (json['title_ar'] ?? json['name_ar']) as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      type: json['type'] as String? ?? 'cod',
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
