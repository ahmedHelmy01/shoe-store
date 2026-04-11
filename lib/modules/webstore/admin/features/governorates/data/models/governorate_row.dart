class GovernorateRow {
  final int id;
  final String name;
  final String? nameAr;
  final bool isActive;

  const GovernorateRow({
    required this.id,
    required this.name,
    this.nameAr,
    required this.isActive,
  });

  factory GovernorateRow.fromJson(Map<String, dynamic> json) {
    return GovernorateRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
