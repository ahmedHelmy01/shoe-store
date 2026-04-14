class CategoryRow {
  final int id;
  final String name;
  final int? parentId;
  final int productsCount;
  final bool isActive;

  CategoryRow({
    required this.id,
    required this.name,
    this.parentId,
    this.productsCount = 0,
    this.isActive = true,
  });

  factory CategoryRow.fromJson(Map<String, dynamic> json) {
    return CategoryRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unnamed Category',
      parentId: json['parentId'] as int?,
      productsCount: json['productsCount'] as int? ?? 0,
      isActive: (json['active'] ?? json['is_active'] ?? true) as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parentId': parentId,
      'productsCount': productsCount,
      'is_active': isActive,
    };
  }
}
