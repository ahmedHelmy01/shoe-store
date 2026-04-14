class CompanyRow {
  final int id;
  final String name;
  final String? code;
  final String country;
  final int productsCount;
  final bool isActive;

  const CompanyRow({
    required this.id,
    required this.name,
    this.code,
    required this.country,
    required this.productsCount,
    required this.isActive,
  });

  factory CompanyRow.fromJson(Map<String, dynamic> json) {
    return CompanyRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      code: json['code'] as String?,
      country: json['country'] as String? ?? 'N/A',
      productsCount: json['products_count'] as int? ?? 0,
      isActive: (json['active'] ?? json['is_active'] ?? true) as bool,
    );
  }
}


