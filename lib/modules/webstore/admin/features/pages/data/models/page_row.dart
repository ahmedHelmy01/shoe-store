class PageRow {
  final int id;
  final String title;
  final String? titleAr;
  final String slug;
  final bool isActive;

  const PageRow({
    required this.id,
    required this.title,
    this.titleAr,
    required this.slug,
    required this.isActive,
  });

  factory PageRow.fromJson(Map<String, dynamic> json) {
    return PageRow(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String?,
      slug: json['slug'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
