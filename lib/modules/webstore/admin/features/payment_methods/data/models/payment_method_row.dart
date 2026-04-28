class PaymentMethodRow {
  final int id;
  final String name;
  final String? nameAr;
  final String? note;
  final String? noteAr;
  final String? image;
  final String type;
  final bool isActive;
  final int sortOrder;

  const PaymentMethodRow({
    required this.id,
    required this.name,
    this.nameAr,
    this.note,
    this.noteAr,
    this.image,
    required this.type,
    required this.isActive,
    required this.sortOrder,
  });

  factory PaymentMethodRow.fromJson(Map<String, dynamic> json) {
    return PaymentMethodRow(
      id: json['id'] as int? ?? 0,
      name: (json['name'] ?? json['title']) as String? ?? '',
      nameAr: (json['name_ar'] ?? json['title_ar']) as String?,
      note: json['note'] as String?,
      noteAr: json['note_ar'] as String?,
      image: json['image'] as String?,
      type: json['type'] as String? ?? 'cod',
      isActive: json['is_active'] == true || json['is_active'] == 1,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'name_ar': nameAr,
      'type': type,
      'sort_order': sortOrder,
      'is_active': isActive,
    };
  }
}
