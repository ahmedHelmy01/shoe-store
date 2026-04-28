class PaymentStatusRow {
  final int id;
  final String name;
  final String? nameAr;
  final String color;
  final int sortOrder;
  final bool isDefault;
  final bool isActive;

  const PaymentStatusRow({
    required this.id,
    required this.name,
    this.nameAr,
    required this.color,
    required this.sortOrder,
    required this.isDefault,
    required this.isActive,
  });

  factory PaymentStatusRow.fromJson(Map<String, dynamic> json) {
    // Handle is_default coming as bool or int (1/0)
    final rawDefault = json['is_default'] ?? json['default'];
    final bool defaultVal = rawDefault is bool 
        ? rawDefault 
        : (rawDefault == 1 || rawDefault == '1');

    return PaymentStatusRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      color: (json['color'] ?? json['hex_color'] ?? json['hexa_color']) as String? ?? '#000000',
      sortOrder: json['sort_order'] as int? ?? 0,
      isDefault: defaultVal,
      isActive: (json['is_active'] == true || json['is_active'] == 1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'name_ar': nameAr,
      'color': color,
      'sort_order': sortOrder,
      'is_default': isDefault,
    };
  }
}
