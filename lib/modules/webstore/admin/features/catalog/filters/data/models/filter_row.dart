class FilterRow {
  final int id;
  final String name;
  final String type; // e.g. "checkbox", "range", "select"
  final int optionsCount;
  final bool isActive;

  const FilterRow({
    required this.id,
    required this.name,
    required this.type,
    required this.optionsCount,
    required this.isActive,
  });

  factory FilterRow.fromJson(Map<String, dynamic> json) {
    return FilterRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'checkbox',
      optionsCount: json['options_count'] as int? ?? 0,
      isActive: (json['active'] ?? json['is_active'] ?? true) as bool,
    );
  }
}
